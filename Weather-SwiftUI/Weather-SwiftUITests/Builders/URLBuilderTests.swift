//
//  URLBuilderTests.swift
//  Weather-SwiftUITests
//
//  Created by Panagiotis Vakalis on 5/9/26.
//

import XCTest
import CoreLocation
@testable import Weather_SwiftUI

final class URLBuilderTests: XCTestCase {
	func testURLBuilder_whenBuildingForCurrentWeatherInCoordinates_shouldReturnTheExpectedURL() throws {
		// Given
		let coordinates = CLLocationCoordinate2D(
			latitude: 37.9838,
			longitude: 23.7278
		)
		let sut = URLBuilder()
		
		// When
		let url = sut.buildForCurrentWeather(in: coordinates)
		
		// Then
		let resultComponents = try XCTUnwrap(
			URLComponents(url: url, resolvingAgainstBaseURL: false)
		)
		XCTAssertEqual(resultComponents.host, "api.open-meteo.com")
		XCTAssertEqual(resultComponents.path, "/v1/forecast")
		XCTAssertEqual(
			Set(resultComponents.queryItems ?? []),
			Set([
				URLQueryItem(name: "latitude", value: "37.9838"),
				URLQueryItem(name: "longitude", value: "23.7278"),
				URLQueryItem(
					name: "current",
					value: "temperature_2m,weather_code,is_day"
				),
				URLQueryItem(name: "timezone", value: "auto")
			])
		)
	}
}
