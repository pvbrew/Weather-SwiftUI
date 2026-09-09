//
//  WeatherConditionMapperTests.swift
//  Weather-SwiftUITests
//
//  Created by Panagiotis Vakalis on 7/9/26.
//

import XCTest
@testable import Weather_SwiftUI

final class WeatherConditionMapperTests: XCTestCase {
	private let sut: WeatherConditionMapper.Type = WeatherConditionMapper.self
	private var unrecognisedWeatherCodes: [Int] {
		let knownWeatherCodes = [
			0, 1, 2, 3, 45, 48, 51, 53, 55, 56, 57, 61, 63, 65, 66, 67,
			71, 73, 75, 77, 80, 81, 82, 85, 86, 95, 96, 99
		]
		return Array(0...100).filter { weatherCode in
			!knownWeatherCodes.contains(weatherCode)
		}
	}
	
	func testMap_whenCodeIsClearAndIsDay_returnsClearDay() {
		// Given
		let weatherCodes = [0, 1]

		// When Then
		weatherCodes.forEach { weatherCode in
			let weatherCondition = sut.map(
				weatherCode: weatherCode,
				isDay: true
			)
			XCTAssertEqual(weatherCondition, .clearDay)
		}
	}

	func testMap_whenCodeIsClearAndIsNight_returnsClearNight() {
		// Given
		let weatherCodes = [0, 1]

		// When Then
		weatherCodes.forEach { weatherCode in
			let weatherCondition = sut.map(
				weatherCode: weatherCode,
				isDay: false
			)
			XCTAssertEqual(weatherCondition, .clearNight)
		}
	}

	func testMap_whenCodeIsPartlyCloudyOrOvercastAndIsDay_returnsCloudy() {
		// Given
		let weatherCodes = [2, 3]

		// When Then
		weatherCodes.forEach { weatherCode in
			let weatherCondition = sut.map(
				weatherCode: weatherCode,
				isDay: true
			)
			XCTAssertEqual(weatherCondition, .cloudy)
		}
	}

	func testMap_whenCodeIsPartlyCloudyOrOvercastAndIsNight_returnsCloudy() {
		// Given
		let weatherCodes = [2, 3]

		// When Then
		weatherCodes.forEach { weatherCode in
			let weatherCondition = sut.map(
				weatherCode: weatherCode,
				isDay: false
			)
			XCTAssertEqual(weatherCondition, .cloudy)
		}
	}

	func testMap_whenCodeIsFogAndIsDay_returnsFog() {
		// Given
		let weatherCodes = [45, 48]

		// When Then
		weatherCodes.forEach { weatherCode in
			let weatherCondition = sut.map(
				weatherCode: weatherCode,
				isDay: true
			)
			XCTAssertEqual(weatherCondition, .fog)
		}
	}

	func testMap_whenCodeIsFogAndIsNight_returnsFog() {
		// Given
		let weatherCodes = [45, 48]

		// When Then
		weatherCodes.forEach { weatherCode in
			let weatherCondition = sut.map(
				weatherCode: weatherCode,
				isDay: false
			)
			XCTAssertEqual(weatherCondition, .fog)
		}
	}

	func testMap_whenCodeIsDrizzleFreezingDrizzleRainOrRainShowersAndIsDay_returnsRain() {
		// Given
		let weatherCodes = [51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82]

		// When Then
		weatherCodes.forEach { weatherCode in
			let weatherCondition = sut.map(
				weatherCode: weatherCode,
				isDay: true
			)
			XCTAssertEqual(weatherCondition, .rain)
		}
	}

	func testMap_whenCodeIsDrizzleFreezingDrizzleRainOrRainShowersAndIsNight_returnsRain() {
		// Given
		let weatherCodes = [51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82]

		// When Then
		weatherCodes.forEach { weatherCode in
			let weatherCondition = sut.map(
				weatherCode: weatherCode,
				isDay: false
			)
			XCTAssertEqual(weatherCondition, .rain)
		}
	}

	func testMap_whenCodeIsSnowFallOrSnowShowersAndIsDay_returnsSnow() {
		// Given
		let weatherCodes = [71, 73, 75, 77, 85, 86]

		// When Then
		weatherCodes.forEach { weatherCode in
			let weatherCondition = sut.map(
				weatherCode: weatherCode,
				isDay: true
			)
			XCTAssertEqual(weatherCondition, .snow)
		}
	}

	func testMap_whenCodeIsSnowFallOrSnowShowersAndIsNight_returnsSnow() {
		// Given
		let weatherCodes = [71, 73, 75, 77, 85, 86]

		// When Then
		weatherCodes.forEach { weatherCode in
			let weatherCondition = sut.map(
				weatherCode: weatherCode,
				isDay: false
			)
			XCTAssertEqual(weatherCondition, .snow)
		}
	}

	func testMap_whenCodeIsThunderstormAndIsDay_returnsThunderstorm() {
		// Given
		let weatherCodes = [95, 96, 99]

		// When Then
		weatherCodes.forEach { weatherCode in
			let weatherCondition = sut.map(
				weatherCode: weatherCode,
				isDay: true
			)
			XCTAssertEqual(weatherCondition, .thunderstorm)
		}
	}

	func testMap_whenCodeIsThunderstormAndIsNight_returnsThunderstorm() {
		// Given
		let weatherCodes = [95, 96, 99]

		// When Then
		weatherCodes.forEach { weatherCode in
			let weatherCondition = sut.map(
				weatherCode: weatherCode,
				isDay: false
			)
			XCTAssertEqual(weatherCondition, .thunderstorm)
		}
	}

	func testMap_whenCodeIsUnrecognisedAndIsDay_returnsUnknown() {
		// When Then
		unrecognisedWeatherCodes.forEach { weatherCode in
			let weatherCondition = sut.map(
				weatherCode: weatherCode,
				isDay: true
			)
			XCTAssertEqual(weatherCondition, .unknown)
		}
	}

	func testMap_whenCodeIsUnrecognisedAndIsNight_returnsUnknown() {
		// When Then
		unrecognisedWeatherCodes.forEach { weatherCode in
			let weatherCondition = sut.map(
				weatherCode: weatherCode,
				isDay: false
			)
			XCTAssertEqual(weatherCondition, .unknown)
		}
	}
}
