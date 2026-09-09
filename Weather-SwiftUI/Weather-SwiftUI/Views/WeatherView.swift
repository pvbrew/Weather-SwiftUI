//
//  WeatherView.swift
//  Weather-SwiftUI
//
//  Created by Panagiotis Vakalis on 31/8/26.
//

import SwiftUI
import CoreLocation
import Combine

struct WeatherView: View {
	@StateObject private var locationManager = LocationManager()
	@EnvironmentObject private var weatherAggregateModel: WeatherAggregateModel
	
	private var currentWeather: CurrentWeather? {
		weatherAggregateModel.currentWeather
	}

	private var isLoading: Bool {
		currentWeather == nil
			&& locationManager.errorAccessingLocation == nil
			&& weatherAggregateModel.errorGettingCurrentWeather == nil
	}

    var body: some View {
		ZStack {
			if let gradient = currentWeather?.weatherCondition.gradient {
				BackgroundGradientView(
					startColour: Color(gradient.start),
					endColour: Color(gradient.end)
				)
			} else {
				BackgroundGradientView(
					startColour: Color(.systemGray6),
					endColour: Color(.systemGray)
				)
			}
			ScrollView {
				VStack {
					if let error = locationManager.errorAccessingLocation {
						Text("Location unavailable: \(error.localizedDescription). Pull to refresh")
							.errorStyle()
					}

					if let error = weatherAggregateModel.errorGettingCurrentWeather {
						Text("Error getting weather: \(error.localizedDescription). Pull to refresh")
							.errorStyle()
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
					} else if isLoading {
						LoadingView()
					}
				}
				.frame(maxWidth: .infinity)
				.containerRelativeFrame(.vertical, alignment: .center)
			}
			.refreshable {
				weatherAggregateModel.resetCurrentWeather()
				await locationManager.requestLocationOrAuthorise()
			}
			.padding()
			.task {
				await locationManager.requestLocationOrAuthorise()
			}
			.onReceive(locationManager.$lastKnownLocation.compactMap { coordinates in
				coordinates
			}) { newLocation in
				Task {
					await weatherAggregateModel.getCurrentWeather(at: newLocation)
				}
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
