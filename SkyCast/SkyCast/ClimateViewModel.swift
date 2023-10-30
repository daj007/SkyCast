//
//  ClimateViewModel.swift
//  SkyCast
//
//  Created by David Amezcua on 10/26/23.
//

import Foundation
import CoreLocation

public class ClimateViewModel: ObservableObject {
    @Published var actualTemperature: String = ""
    @Published var minTemperature: String = ""
    @Published var maxTemperature: String = ""
    @Published var weatherIcon: String = ""
    @Published var weatherDescription = "XXXX"
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    @Published var isLoading = true
    @Published var dataReady: Bool = false
    
    public let climateService: ClimateService
    
    public init(climateService: ClimateService) {
        self.climateService = climateService
    }
    
    public func refresh(_ cityData: CityViewModel) {
        let completionHandler: (Climate) -> Void = { climate in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.weatherIcon = climate.iconName ?? ""
                self.actualTemperature = "\(climate.temperature)ºF"
                self.minTemperature = "\(climate.tempMin)ºF"
                self.maxTemperature = "\(climate.tempMax)ºF"
                self.weatherDescription = climate.description?.capitalized ?? ""
                self.isLoading = false
                self.dataReady = true
            }
        }
        if let latitude = cityData.latitude, let longitude = cityData.longitude {
            self.latitude = latitude
            self.longitude = longitude
            self.climateService.loadWeatherData(CLLocationCoordinate2DMake(self.latitude, self.longitude), completionHandler: completionHandler)
        } else {
            self.climateService.loadWeatherData(completionHandler: completionHandler)
        }
    }
}
