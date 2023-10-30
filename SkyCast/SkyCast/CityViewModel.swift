//
//  CityViewModel.swift
//  SkyCast
//
//  Created by David Amezcua on 10/27/23.
//

import Foundation
import Combine

public class CityViewModel: ObservableObject {
    @Published var inputData: String = ""
    @Published var cityName: String = ""
    @Published var stateName: String = ""
    @Published var longitude: Double?
    @Published var latitude: Double?
    @Published var isLoading: Bool = false
    @Published var dataReady: Bool = false
    
    private let cityDataKey = "cityData"
    
    public let cityService: CityService
    
    public init(cityService: CityService) {
        self.cityService = cityService
        if let savedData = UserDefaults.standard.data(forKey: cityDataKey) {
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode(DataCity.self, from: savedData) {
                self.fillDataWith(cityData: decodedData)
            }
        }
    }
    
    private func fillDataWith( cityData: DataCity) {
        self.cityName = cityData.name
        self.stateName = cityData.state
        self.longitude = cityData.lon
        self.latitude = cityData.lat
        dataReady = true
    }
    
    public func refresh() {
        
        self.isLoading = true
        
        let separatedArray = inputData.components(separatedBy: ", ")
        
        cityService.loadCityData(separatedArray, completionHandler: { city in
            DispatchQueue.main.async {
                let encoder = JSONEncoder()
                if let encodedData = try? encoder.encode(city) {
                    UserDefaults.standard.set(encodedData, forKey: self.cityDataKey)
                }
                self.fillDataWith(cityData: city)
                self.isLoading = false
            }
        })
    }
}
