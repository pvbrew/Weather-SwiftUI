//
//  CurrentWeatherMapperTests.swift
//  Weather-SwiftUITests
//
//  Created by Panagiotis Vakalis on 8/9/26.
//

import XCTest
@testable import Weather_SwiftUI

final class CurrentWeatherMapperTests: XCTestCase {
	// MARK: - Properties
	private let sut: CurrentWeatherMapper.Type = CurrentWeatherMapper.self
	
	// MARK: - map(weather:) tests
	func testCurrentWeatherMapper_whenMappingWeatherWithTemperatureValueAndUnit_shouldReturnTheExpectedTemperatureText() {
		// Given
		let weather = CurrentWeatherResponse(
			units: CurrentWeatherResponse.Units(temperature: "°C"),
			values: CurrentWeatherResponse.Values(
				temperature: 25.5,
				weatherCode: nil,
				isDay: nil
			)
		)
		
		// When
		let currentWeather = sut.map(weather: weather)
		
		// Then
		XCTAssertEqual(currentWeather.temperature, "25.5°C")
	}
	
	func testCurrentWeatherMapper_whenMappingWeatherWithoutTemperatureUnit_shouldReturnTheExpectedTemperatureText() {
		// Given
		let weather = CurrentWeatherResponse(
			units: CurrentWeatherResponse.Units(temperature: nil),
			values: CurrentWeatherResponse.Values(
				temperature: 25.5,
				weatherCode: nil,
				isDay: nil
			)
		)
		
		// When
		let currentWeather = sut.map(weather: weather)
		
		// Then
		XCTAssertEqual(currentWeather.temperature, "--")
	}
	
	func testCurrentWeatherMapper_whenMappingWeatherWithoutTemperatureValue_shouldReturnTheExpectedTemperatureText() {
			// Given
		let weather = CurrentWeatherResponse(
			units: CurrentWeatherResponse.Units(temperature: "°C"),
			values: CurrentWeatherResponse.Values(
				temperature: nil,
				weatherCode: nil,
				isDay: nil
			)
		)
		
		// When
		let currentWeather = sut.map(weather: weather)
		
		// Then
		XCTAssertEqual(currentWeather.temperature, "--")
	}
	
	func testCurrentWeatherMapper_whenMappingWeatherWithoutTemperatureValueAndUnit_shouldReturnTheExpectedTemperatureText() {
		// Given
		let weather = CurrentWeatherResponse(
			units: CurrentWeatherResponse.Units(temperature: nil),
			values: CurrentWeatherResponse.Values(
				temperature: nil,
				weatherCode: nil,
				isDay: nil
			)
		)
		
		// When
		let currentWeather = sut.map(weather: weather)
		
		// Then
		XCTAssertEqual(currentWeather.temperature, "--")
	}
	
	func testCurrentWeatherMapper_whenMappingWeatherWithWeatherCode_shouldReturnTheExpectedWeatherCondition() {
		// Given
		let weather = CurrentWeatherResponse(
			units: CurrentWeatherResponse.Units(temperature: nil),
			values: CurrentWeatherResponse.Values(
				temperature: nil,
				weatherCode: 45,
				isDay: nil
			)
		)
		
		// When
		let currentWeather = sut.map(weather: weather)
		
		// Then
		XCTAssertEqual(currentWeather.weatherCondition, .fog)
	}
	
	func testCurrentWeatherMapper_whenMappingWeatherWithoutWeatherCode_shouldReturnTheExpectedWeatherCondition() {
		// Given
		let weather = CurrentWeatherResponse(
			units: CurrentWeatherResponse.Units(temperature: nil),
			values: CurrentWeatherResponse.Values(
				temperature: nil,
				weatherCode: nil,
				isDay: nil
			)
		)
		
		// When
		let currentWeather = sut.map(weather: weather)
		
		// Then
		XCTAssertEqual(currentWeather.weatherCondition, .unknown)
	}
	
	func testCurrentWeatherMapper_whenMappingWeatherWhenIsDay_shouldReturnTheExpectedWeatherCondition() {
		// Given
		let weather = CurrentWeatherResponse(
			units: CurrentWeatherResponse.Units(temperature: nil),
			values: CurrentWeatherResponse.Values(
				temperature: nil,
				weatherCode: 1,
				isDay: 1
			)
		)
		
		// When
		let currentWeather = sut.map(weather: weather)
		
		// Then
		XCTAssertEqual(currentWeather.weatherCondition, .clearDay)
	}
	
	func testCurrentWeatherMapper_whenMappingWeatherWhenIsNotDay_shouldReturnTheExpectedWeatherCondition() {
		// Given
		let weather = CurrentWeatherResponse(
			units: CurrentWeatherResponse.Units(temperature: nil),
			values: CurrentWeatherResponse.Values(
				temperature: nil,
				weatherCode: 1,
				isDay: 0
			)
		)
		
		// When
		let currentWeather = sut.map(weather: weather)
		
		// Then
		XCTAssertEqual(currentWeather.weatherCondition, .clearNight)
	}
	
	func testCurrentWeatherMapper_whenMappingWeatherWithoutisDay_shouldReturnTheExpectedWeatherCondition() {
		// Given
		let weather = CurrentWeatherResponse(
			units: CurrentWeatherResponse.Units(temperature: nil),
			values: CurrentWeatherResponse.Values(
				temperature: nil,
				weatherCode: 1,
				isDay: nil
			)
		)
		
		// When
		let currentWeather = sut.map(weather: weather)
		
		// Then
		XCTAssertEqual(currentWeather.weatherCondition, .clearDay)
	}
}
