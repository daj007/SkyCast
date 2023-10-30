//
//  WeatherInformationView.swift
//  SkyCast
//
//  Created by David Amezcua on 10/26/23.
//

import SwiftUI

struct WeatherInformationView: View {
    
    let cViewModel: CityViewModel

    @StateObject var viewModel: ClimateViewModel = ClimateViewModel(climateService: ClimateService())
    @State public var isLoading: Bool = true
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .cyan, .cyan, .cyan, .white]),
                           startPoint: .bottom, endPoint: .top)
            if isLoading {
                ProgressView()
                    .onAppear{
                        viewModel.refresh(cViewModel)
                    }
                    .onReceive(viewModel.$isLoading, perform: { isLoading in
                        self.isLoading = isLoading
                    })
            } else {
                VStack {
                    Text(cViewModel.cityName)
                        .font(.largeTitle)
                        .padding(.top, 30)
                    Text(cViewModel.stateName)
                        .font(.title)
                        .padding(.bottom, 50)
                    Text("Current Temperature")
                    Text(viewModel.actualTemperature)
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    Text("Temperature Range")
                        .padding(.top, 40)
                    Text("\(viewModel.minTemperature) - \(viewModel.maxTemperature)")
                            .font(.title3)
                    IconView(iconCode: viewModel.weatherIcon)
                    Text(viewModel.weatherDescription)
                    Spacer()
                }
                .padding()
                .navigationTitle("City Weather Details")
            }
        }
    }
}

struct IconView: View {
    var iconCode: String
    @State private var icon: UIImage? = nil
        var body: some View {
            if let icon = icon {
                Image(uiImage: icon)
                    .frame(width: 35)
            } else {
                ProgressView()
                    .onAppear {
                        var iconURL = URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png")
                        if let iconURL = iconURL{
                            downloadImage(fromURL: iconURL) { downloadedImage in
                                if let downloadedImage = downloadedImage {
                                    self.icon = downloadedImage
                                }
                            }
                        }
                    }
            }
        }
    
    func downloadImage(fromURL url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
