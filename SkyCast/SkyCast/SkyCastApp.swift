//
//  SkyCastApp.swift
//  SkyCast
//
//  Created by David Amezcua on 10/26/23.
//

import SwiftUI

@main
struct SkyCastApp: App {
    var body: some Scene {
        WindowGroup {
            let cityService = CityService()
            let viewModel = CityViewModel(cityService: cityService)
            ContentView(viewModel: viewModel)
        }
    }
}
