//
//  ClimateService.swift
//  SkyCast
//
//  Created by David Amezcua on 10/26/23.
//

import Foundation
import CoreLocation

public final class ClimateService: NSObject {
    private let locationManager = CLLocationManager()
    private let API_KEY = "a83e8d9dcb6f01f5e74e6e46b094109d"
    private var completionHandler: ((Climate) -> Void)?
    
    public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        switch locationManager.authorizationStatus {
        case .restricted, .denied, .notDetermined:
            locationManager.requestLocation()
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location Authorized")
        @unknown default:
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    public func loadWeatherData(_ coordinates: CLLocationCoordinate2D? = nil, completionHandler: @escaping(Climate) -> Void) {
        self.completionHandler = completionHandler
        if let coordinates {
            self.makeDataRequest(forCoordinatets: coordinates)
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    private func makeDataRequest(forCoordinatets coordinates: CLLocationCoordinate2D) {
        
        guard let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(API_KEY)&units=imperial".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else { return }
            
            if let response = try? JSONDecoder().decode(OpenWeatherAPI.self, from: data) {
                self.completionHandler?(Climate(response: response))
            }
        }.resume()
    }
}
extension ClimateService: CLLocationManagerDelegate {
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .restricted, .denied, .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location Authorized")
        @unknown default:
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        self.makeDataRequest(forCoordinatets: location.coordinate)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("CLLocationManager error \(error)")
    }
}

// MARK: - OpenWeatherAPI
struct OpenWeatherAPI: Decodable {
    let weather: [Weather]
    let main: MainClass
}

//// MARK: - City
//struct City: Decodable {
//    let id: Int
//    let name: String
//}
//
//// MARK: - List
//struct OWList: Decodable {
//    let dt: Int
//    
//}

// MARK: - MainClass
struct MainClass: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

// MARK: - Weather
struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
