//
//  MockAPIClient.swift
//  Weather-SwiftUITests
//
//  Created by Panagiotis Vakalis on 8/9/26.
//

import Foundation
import CoreLocation
@testable import Weather_SwiftUI

final class MockAPIClient: APIClientProtocol {
	private(set) var getCurrentWeatherCallCount = 0
	private(set) var getCurrentWeatherReceivedCoordinates: CLLocationCoordinate2D?
	var getCurrentWeatherResult: Result<CurrentWeatherResponse, Error> = .success(
		CurrentWeatherResponse(
			units: .init(temperature: "°C"),
			values: .init(temperature: 21.3, weatherCode: 0, isDay: 1)
		)
	)

	func getCurrentWeather(
		at coordinates: CLLocationCoordinate2D
	) async throws -> CurrentWeatherResponse {
		getCurrentWeatherCallCount += 1
		getCurrentWeatherReceivedCoordinates = coordinates
		return try getCurrentWeatherResult.get()
	}
}
