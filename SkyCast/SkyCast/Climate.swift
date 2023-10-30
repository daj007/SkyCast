//
//  Climate.swift
//  SkyCast
//
//  Created by David Amezcua on 10/26/23.
//

import Foundation

public struct Climate {
    var temperature: Double = 0.0
    var feelsLike: Double = 0.0
    var tempMin: Double = 0.0
    var tempMax: Double = 0.0
    var description: String?
    var iconName: String?
    
    init(response: OpenWeatherAPI){
        self.temperature = response.main.temp
        self.feelsLike = response.main.feelsLike
        self.tempMax = response.main.tempMax
        self.tempMin = response.main.tempMin
        self.description = response.weather.first?.description
        self.iconName = response.weather.first?.icon
    }
}
