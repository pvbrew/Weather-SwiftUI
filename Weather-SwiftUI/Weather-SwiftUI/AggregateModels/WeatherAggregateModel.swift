//
//  WeatherAggregateModel.swift
//  Weather-SwiftUI
//
//  Created by Panagiotis Vakalis on 8/9/26.
//

import Foundation
import Combine
import CoreLocation

@MainActor
final class WeatherAggregateModel: ObservableObject {
	// MARK: - Published properties
	@Published private(set) var currentWeather: CurrentWeather?
	@Published private(set) var errorGettingCurrentWeather: Error?
	@Published private(set) var isGettingCurrentWeather = false
	
	// MARK: - Properties
	private let apiClient: APIClientProtocol
	
	// MARK: - Initialisers
	init(apiClient: APIClientProtocol) {
		self.apiClient = apiClient
	}
	
	// MARK: - Functions
	func getCurrentWeather(at coordinates: CLLocationCoordinate2D?) async {
		errorGettingCurrentWeather = nil
		guard let coordinates else {
			errorGettingCurrentWeather = WeatherError.noCoordinates
			return
		}
		isGettingCurrentWeather = true
		defer { isGettingCurrentWeather = false }
		do {
			let currentWeatherResponse = try await apiClient.getCurrentWeather(
				at: coordinates
			)
			currentWeather = CurrentWeatherMapper.map(
				weather: currentWeatherResponse
			)
		} catch {
			errorGettingCurrentWeather = error
		}
	}
	
	func resetCurrentWeather() {
		currentWeather = nil
	}
}

extension WeatherAggregateModel {
	enum WeatherError: Error, Equatable {
		case noCoordinates
	}
}
