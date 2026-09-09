//
//  WeatherView.swift
//  Weather-SwiftUI
//
//  Created by Panagiotis Vakalis on 31/8/26.
//

import SwiftUI
import CoreLocation

struct WeatherView: View {
	@StateObject private var locationManager = LocationManager()
	@EnvironmentObject private var weatherAggregateModel: WeatherAggregateModel
	
	private var currentWeather: CurrentWeather? {
		weatherAggregateModel.currentWeather
	}
	
    var body: some View {
		ZStack {
			if let gradient = currentWeather?.weatherCondition.gradient {
				BackgroundGradientView(startColour: Color(gradient.start), endColour: Color(gradient.end))
			} else {
				BackgroundGradientView(startColour: Color(.systemGray6), endColour: Color(.systemGray))
			}
			VStack {
				if let coordinate = locationManager.lastKnownLocation {
					Text("Latitude: \(coordinate.latitude)")
					
					Text("Longitude: \(coordinate.longitude)")
				} else if let error = locationManager.errorAccessingLocation {
					Text("Location unavailable: \(error.localizedDescription)")
				} else {
					Text("Unknown Location")
				}
				
				if let error = weatherAggregateModel.errorGettingCurrentWeather {
					Text("Error getting weather: \(error.localizedDescription)")
				}
				
				if let currentWeather = weatherAggregateModel.currentWeather {
					Image(systemName: currentWeather.weatherCondition.imageName)
						.font(Typography.weatherConditionLarge)
						.foregroundStyle(Color(currentWeather.weatherCondition.accent))
					Text(currentWeather.temperature)
						.font(Typography.heroTemperature)
						.foregroundStyle(.textColour)
					Text(currentWeather.weatherCondition.title)
						.font(Typography.weatherConditionTitleLarge)
						.foregroundStyle(.textColour)
				}
				Button {
					Task {
						await locationManager.requestLocationIfAuthorised()
					}
				} label: {
					if locationManager.isRequestingLocation {
						ProgressView()
					} else {
						Text("Get location")
					}
				}
				.buttonStyle(.borderedProminent)
				.disabled(locationManager.isRequestingLocation)
				
				Button("Get weather") {
					Task {
						await weatherAggregateModel.getCurrentWeather(at: locationManager.lastKnownLocation)
					}
				}
				.buttonStyle(.borderedProminent)
				.disabled(weatherAggregateModel.isGettingCurrentWeather)
			}
			.padding()
			.task {
				await locationManager.checkLocationAuthorisationAsync()
			}
			.alert("Location Access Denied", isPresented: $locationManager.isAuthorisationDenied) {
				Button("Cancel", role: .cancel) {}
				Button("Open Settings") {
					if let url = URL(string: UIApplication.openSettingsURLString) {
						UIApplication.shared.open(url)
					}
				}
			} message: {
				Text("Weather-SwiftUI needs access to your location to show local weather. Enable it in Settings.")
			}
		}
    }
}

#Preview {
    WeatherView()
		.environmentObject(WeatherAggregateModel(apiClient: APIClient()))
}
