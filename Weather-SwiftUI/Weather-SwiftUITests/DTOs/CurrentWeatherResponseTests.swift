//
//  CurrentWeatherResponseTests.swift
//  Weather-SwiftUITests
//
//  Created by Panagiotis Vakalis on 4/9/26.
//

import XCTest
@testable import Weather_SwiftUI

final class CurrentWeatherResponseTests: XCTestCase {
	// MARK: - CurrentWeatherResponse decoding tests
	func testCurrentWeatherResponse_whenDecodedWithAllTheProperties_sutShouldHaveAllTheProperties() throws {
		// Given
		let fileName = "current_weather"
		
		// When
		let sut = try makeSut(CurrentWeatherResponse.self, from: fileName)
		
		// Then
		XCTAssertNotNil(sut.units)
		XCTAssertNotNil(sut.values)
	}
	
	func testCurrentWeatherResponse_whenDecodedWithNoCurrent_sutShouldHaveOnlyUnits() throws {
		// Given
		let fileName = "current_weather_no_current"
		
		// When
		let sut = try makeSut(CurrentWeatherResponse.self, from: fileName)
		
		// Then
		XCTAssertNotNil(sut.units)
		XCTAssertNil(sut.values)
	}
	
	func testCurrentWeatherResponse_whenDecodedWithNoCurrentUnits_sutShouldHaveOnlyValues() throws {
		// Given
		let fileName = "current_weather_no_current_units"
		
		// When
		let sut = try makeSut(CurrentWeatherResponse.self, from: fileName)
		
		// Then
		XCTAssertNil(sut.units)
		XCTAssertNotNil(sut.values)
	}
	
	// MARK: - CurrentWeatherResponse.Units decoding tests
	func testCurrentWeatherResponseUnits_whenDecodedWithAllTheProperties_sutShouldHaveAllTheProperties() throws {
		// Given
		let fileName = "current_units"
		
		// When
		let sut = try makeSut(CurrentWeatherResponse.Units.self, from: fileName)
		
		// Then
		XCTAssertEqual(sut.temperature, "°C")
	}
	
	func testCurrentWeatherResponseUnits_whenDecodedWithNoValues_sutShouldHaveNilProperties() throws {
		// Given
		let fileName = "empty"
		
		// When
		let sut = try makeSut(CurrentWeatherResponse.Units.self, from: fileName)
		
		// Then
		XCTAssertNil(sut.temperature)
	}
	
	// MARK: - CurrentWeatherResponse.Values decoding tests
	func testCurrentWeatherResponseValues_whenDecodedWithAllTheProperties_sutShouldHaveAllTheProperties() throws {
		// Given
		let fileName = "current_values"
		
		// When
		let sut = try makeSut(
			CurrentWeatherResponse.Values.self,
			from: fileName
		)
		
		// Then
		XCTAssertEqual(sut.temperature, 31.9)
		XCTAssertEqual(sut.weatherCode, 2)
		XCTAssertEqual(sut.isDay, 1)
	}
	
	func testCurrentWeatherResponseValues_whenDecodedWithNoValues_sutShouldHaveNilProperties() throws {
		// Given
		let fileName = "empty"
		
		// When
		let sut = try makeSut(
			CurrentWeatherResponse.Values.self,
			from: fileName
		)
		
		// Then
		XCTAssertNil(sut.temperature)
		XCTAssertNil(sut.weatherCode)
		XCTAssertNil(sut.isDay)
	}
	
	// MARK: - Helper functions
	private func makeSut<T: Decodable>(
		_ type: T.Type,
		from fileName: String
	) throws -> T {
		let bundle = Bundle(for: Swift.type(of: self))
		let url = try XCTUnwrap(
			bundle.url(forResource: fileName, withExtension: "json")
		)
		let data = try Data(contentsOf: url)
		return try JSONDecoder().decode(type, from: data)
	}
}
