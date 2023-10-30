//
//  ContentView.swift
//  SkyCast
//
//  Created by David Amezcua on 10/26/23.
//

import SwiftUI
import Combine



struct ContentView: View {
    
    @ObservedObject var viewModel: CityViewModel
    @State private var readyToNavigate : Bool = false
    
    var body: some View{
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .cyan, .cyan, .cyan, .white]), startPoint: .bottom, endPoint: .top)
                
                VStack {
                    HStack{
                        TextField("Enter Data", text: $viewModel.inputData)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .padding(.leading)
                        Button(action: {
                            viewModel.latitude = nil
                            viewModel.longitude = nil
                            self.readyToNavigate = true
                        }) {
                            
                            Image(systemName: "location.fill")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.trailing)
                    }
                    Button("Fetch Data") {
                        viewModel.refresh()
                    }
                    .disabled(viewModel.isLoading)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding()
                    
                    if viewModel.isLoading {
                        ProgressView("Loading...")
                    }
                    
                }
                .navigationDestination(isPresented: $readyToNavigate) {
                    WeatherInformationView(cViewModel: viewModel, isLoading: true)
                }
                .navigationTitle("SkyCast App")
            }
        }
        .onReceive(viewModel.$dataReady) { data in
            if data {
                self.readyToNavigate = true
            }
        }
    }
}

#Preview {
    ContentView(viewModel: CityViewModel(cityService: CityService()))
}
