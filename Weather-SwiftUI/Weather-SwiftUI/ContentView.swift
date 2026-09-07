//
//  ContentView.swift
//  Weather-SwiftUI
//
//  Created by Panagiotis Vakalis on 31/8/26.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
	@StateObject private var locationManager = LocationManager()
	
    var body: some View {
		VStack {
			if let coordinate = locationManager.lastKnownLocation {
				Text("Latitude: \(coordinate.latitude)")
				
				Text("Longitude: \(coordinate.longitude)")
			} else if let error = locationManager.errorAccessingLocation {
				Text("Location unavailable: \(error.localizedDescription)")
			} else {
				Text("Unknown Location")
			}
			
			
			Button("Get location") {
				locationManager.requestLocation()
			}
			.buttonStyle(.borderedProminent)
			
			Button("Get weather") {
				Task {
					guard let coordinates = locationManager.lastKnownLocation else { return }

					let weather = try await APIClient().getCurrentWeather(at: coordinates)
					guard let weatherCode = weather.values?.weatherCode,
						  let isDay = weather.values?.isDay else { return }

					let weatherCondition = WeatherConditionMapper.map(
						weatherCode: weatherCode,
						isDay: isDay == 1
					)
					print(weatherCondition)
				}
			}
			.buttonStyle(.borderedProminent)
		}
		.padding()
		.task {
			locationManager.checkLocationAuthorisation()
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

#Preview {
    ContentView()
}
