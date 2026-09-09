//
//  WeatherAggregateModelTests.swift
//  Weather-SwiftUITests
//
//  Created by Panagiotis Vakalis on 8/9/26.
//

import XCTest
import CoreLocation
@testable import Weather_SwiftUI

@MainActor
final class WeatherAggregateModelTests: XCTestCase {
	private let coordinates = CLLocationCoordinate2D(
		latitude: 0.0,
		longitude: 0.0
	)

	// MARK: - getCurrentWeather(at:) tests
	func testGetCurrentWeather_whenCoordinatesAreNil_shouldSetNoCoordinatesError() async {
		// Given
		let (sut, _) = makeSUT()

		// When
		await sut.getCurrentWeather(at: nil)

		// Then
		XCTAssertEqual(
			sut.errorGettingCurrentWeather as? WeatherAggregateModel.WeatherError,
			.noCoordinates
		)
	}

	func testGetCurrentWeather_whenCoordinatesAreNil_shouldNotCallAPIClient() async {
		// Given
		let (sut, apiClient) = makeSUT()

		// When
		await sut.getCurrentWeather(at: nil)

		// Then
		XCTAssertEqual(apiClient.getCurrentWeatherCallCount, 0)
	}

	func testGetCurrentWeather_whenCoordinatesAreNil_shouldNotSetCurrentWeather() async {
		// Given
		let (sut, _) = makeSUT()

		// When
		await sut.getCurrentWeather(at: nil)

		// Then
		XCTAssertNil(sut.currentWeather)
	}

	func testGetCurrentWeather_whenAPIClientSucceeds_shouldPublishTheMappedCurrentWeather() async {
		// Given
		let (sut, _) = makeSUT()

		// When
		await sut.getCurrentWeather(at: coordinates)

		// Then
		XCTAssertEqual(sut.currentWeather?.temperature, "21.3°C")
		XCTAssertEqual(sut.currentWeather?.weatherCondition, .clearDay)
	}

	func testGetCurrentWeather_whenAPIClientSucceeds_shouldClearAnyPreviousError() async {
		// Given
		let (sut, _) = makeSUT()

		// When
		await sut.getCurrentWeather(at: coordinates)

		// Then
		XCTAssertNil(sut.errorGettingCurrentWeather)
	}

	func testGetCurrentWeather_whenAPIClientSucceeds_shouldSetIsGettingCurrentWeatherToFalse() async {
		// Given
		let (sut, _) = makeSUT()

		// When
		await sut.getCurrentWeather(at: coordinates)

		// Then
		XCTAssertFalse(sut.isGettingCurrentWeather)
	}

	func testGetCurrentWeather_whenAPIClientSucceeds_shouldPropagateCoordinatesToAPIClient() async {
		// Given
		let (sut, apiClient) = makeSUT()

		// When
		await sut.getCurrentWeather(at: coordinates)

		// Then
		XCTAssertEqual(
			apiClient.getCurrentWeatherReceivedCoordinates?.latitude,
			coordinates.latitude
		)
		XCTAssertEqual(
			apiClient.getCurrentWeatherReceivedCoordinates?.longitude,
			coordinates.longitude
		)
	}

	func testGetCurrentWeather_whenAPIClientThrows_shouldSetTheError() async {
		// Given
		let (sut, _) = makeSUT(
			apiClientResult: .failure(NSError(domain: "domain", code: 1))
		)

		// When
		await sut.getCurrentWeather(at: coordinates)

		// Then
		XCTAssertEqual((sut.errorGettingCurrentWeather as? NSError)?.domain, "domain")
	}

	func testGetCurrentWeather_whenAPIClientThrows_shouldNotSetCurrentWeather() async {
		// Given
		let (sut, _) = makeSUT(
			apiClientResult: .failure(NSError(domain: "domain", code: 1))
		)

		// When
		await sut.getCurrentWeather(at: coordinates)

		// Then
		XCTAssertNil(sut.currentWeather)
	}

	func testGetCurrentWeather_whenAPIClientThrows_shouldSetIsGettingCurrentWeatherToFalse() async {
		// Given
		let (sut, _) = makeSUT(
			apiClientResult: .failure(NSError(domain: "domain", code: 1))
		)

		// When
		await sut.getCurrentWeather(at: coordinates)

		// Then
		XCTAssertFalse(sut.isGettingCurrentWeather)
	}

	func testGetCurrentWeather_whenPreviousCallFailedAndNewCallSucceeds_shouldClearThePreviousError() async {
		// Given
		let (sut, apiClient) = makeSUT(
			apiClientResult: .failure(NSError(domain: "domain", code: 1))
		)
		await sut.getCurrentWeather(at: coordinates)
		apiClient.getCurrentWeatherResult = .success(
			CurrentWeatherResponse(
				units: CurrentWeatherResponse.Units(temperature: "°C"),
				values: CurrentWeatherResponse.Values(
					temperature: 21.3,
					weatherCode: 0,
					isDay: 1
				)
			)
		)

		// When
		await sut.getCurrentWeather(at: coordinates)

		// Then
		XCTAssertNil(sut.errorGettingCurrentWeather)
	}
	
	// MARK: - resetCurrentWeather() tests
	func testResetCurrentWeather_whenCalled_shouldSetCurrentWeatherToNil() async {
		// Given
		let (sut, _) = makeSUT()
		await sut.getCurrentWeather(at: coordinates)
		XCTAssertNotNil(sut.currentWeather)
		
		// When
		sut.resetCurrentWeather()
		
		// Then
		XCTAssertNil(sut.currentWeather)
	}

	// MARK: - Helper functions
	private func makeSUT(
		apiClientResult: Result<CurrentWeatherResponse, Error>? = nil
	) -> (sut: WeatherAggregateModel, apiClient: MockAPIClient) {
		let apiClient = MockAPIClient()
		if let apiClientResult {
			apiClient.getCurrentWeatherResult = apiClientResult
		}
		let sut = WeatherAggregateModel(apiClient: apiClient)
		return (sut, apiClient)
	}
}
