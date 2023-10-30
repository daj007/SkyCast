//
//  CityService.swift
//  SkyCast
//
//  Created by David Amezcua on 10/27/23.
//

import Foundation

public final class CityService: NSObject {
    private let API_KEY = "a83e8d9dcb6f01f5e74e6e46b094109d"
    private var completionHandler: ((DataCity) -> Void)?
    private var city: String?
    private var state: String?
    
    public override init() {
        super.init()
    }
    
    public func loadCityData(_ location: [String], completionHandler: @escaping(DataCity) -> Void) {
        self.completionHandler = completionHandler
        if location.first == "" {
            makeDataRequestFor()
        } else {
            self.city = location[0]
            if location.count > 1 {
                self.state = location[1]
            }
            self.makeDataRequestFor()
        }
    }
    
    private func makeDataRequestFor() {
        var urlString = ""
        if let city = self.city {
            if let state = self.state {
                urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(city),\(state),US&limit=1&appid=\(API_KEY)"
            } else {
                urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(city)&limit=1&appid=\(API_KEY)"
            }
        }
        
        guard let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else { return }
            
            if let response = try? JSONDecoder().decode(GeocodingAPI.self, from: data) {
                self.completionHandler?(DataCity(response: response.first!))
            }
        }.resume()
    }
}

// MARK: - OpenWeatherAPI
struct GeocodingAPIElement: Decodable {
    let country: String
    let lat, lon: Double
    let name: String
    let state: String
}

typealias GeocodingAPI = [GeocodingAPIElement]
