//
//  DataCity.swift
//  SkyCast
//
//  Created by David Amezcua on 10/27/23.
//

import Foundation

public struct DataCity: Codable {
    let name: String
    let state: String
    let lon: Double
    let lat: Double
    
    init(response: GeocodingAPIElement) {
        self.name = response.name
        self.state = response.state
        self.lon = response.lon
        self.lat = response.lat
    }
}
