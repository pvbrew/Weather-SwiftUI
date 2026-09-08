//
//  WeatherConditionTests.swift
//  Weather-SwiftUITests
//
//  Created by Panagiotis Vakalis on 8/9/26.
//

import XCTest
@testable import Weather_SwiftUI

final class WeatherConditionTests: XCTestCase {
	// MARK: - title tests
	func testTitle_whenClearDay_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.clearDay
		
		// When
		let title = condition.title
		
		// Then
		XCTAssertEqual(title, "Clear Day")
	}

	func testTitle_whenClearNight_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.clearNight

		// When
		let title = condition.title

		// Then
		XCTAssertEqual(title, "Clear Night")
	}

	func testTitle_whenCloudy_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.cloudy

		// When
		let title = condition.title

		// Then
		XCTAssertEqual(title, "Cloudy")
	}

	func testTitle_whenRain_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.rain

		// When
		let title = condition.title

		// Then
		XCTAssertEqual(title, "Rain")
	}

	func testTitle_whenSnow_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.snow

		// When
		let title = condition.title

		// Then
		XCTAssertEqual(title, "Snow")
	}

	func testTitle_whenThunderstorm_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.thunderstorm

		// When
		let title = condition.title

		// Then
		XCTAssertEqual(title, "Thunderstorm")
	}

	func testTitle_whenFog_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.fog

		// When
		let title = condition.title

		// Then
		XCTAssertEqual(title, "Fog")
	}

	func testTitle_whenUnknown_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.unknown

		// When
		let title = condition.title

		// Then
		XCTAssertEqual(title, "--")
	}

	// MARK: - imageName tests
	func testImageName_whenClearDay_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.clearDay

		// When
		let imageName = condition.imageName

		// Then
		XCTAssertEqual(imageName, "sun.max.fill")
	}

	func testImageName_whenClearNight_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.clearNight

		// When
		let imageName = condition.imageName

		// Then
		XCTAssertEqual(imageName, "moon.fill")
	}

	func testImageName_whenCloudy_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.cloudy

		// When
		let imageName = condition.imageName

		// Then
		XCTAssertEqual(imageName, "cloud.fill")
	}

	func testImageName_whenRain_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.rain

		// When
		let imageName = condition.imageName

		// Then
		XCTAssertEqual(imageName, "cloud.rain.fill")
	}

	func testImageName_whenSnow_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.snow

		// When
		let imageName = condition.imageName

		// Then
		XCTAssertEqual(imageName, "cloud.snow.fill")
	}

	func testImageName_whenThunderstorm_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.thunderstorm

		// When
		let imageName = condition.imageName

		// Then
		XCTAssertEqual(imageName, "cloud.bolt.fill")
	}

	func testImageName_whenFog_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.fog

		// When
		let imageName = condition.imageName

		// Then
		XCTAssertEqual(imageName, "cloud.fog.fill")
	}

	func testImageName_whenUnknown_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.unknown

		// When
		let imageName = condition.imageName

		// Then
		XCTAssertEqual(imageName, "thermometer.variable")
	}

	// MARK: - gradient tests
	func testGradient_whenClearDay_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.clearDay

		// When
		let gradient = condition.gradient

		// Then
		XCTAssertEqual(gradient.start, .ConditionColours.ClearDay.start)
		XCTAssertEqual(gradient.end, .ConditionColours.ClearDay.end)
	}

	func testGradient_whenClearNight_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.clearNight

		// When
		let gradient = condition.gradient

		// Then
		XCTAssertEqual(gradient.start, .ConditionColours.ClearNight.start)
		XCTAssertEqual(gradient.end, .ConditionColours.ClearNight.end)
	}

	func testGradient_whenCloudy_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.cloudy

		// When
		let gradient = condition.gradient

		// Then
		XCTAssertEqual(gradient.start, .ConditionColours.Cloudy.start)
		XCTAssertEqual(gradient.end, .ConditionColours.Cloudy.end)
	}

	func testGradient_whenRain_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.rain

		// When
		let gradient = condition.gradient

		// Then
		XCTAssertEqual(gradient.start, .ConditionColours.Rain.start)
		XCTAssertEqual(gradient.end, .ConditionColours.Rain.end)
	}

	func testGradient_whenSnow_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.snow

		// When
		let gradient = condition.gradient

		// Then
		XCTAssertEqual(gradient.start, .ConditionColours.Snow.start)
		XCTAssertEqual(gradient.end, .ConditionColours.Snow.end)
	}

	func testGradient_whenThunderstorm_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.thunderstorm

		// When
		let gradient = condition.gradient

		// Then
		XCTAssertEqual(gradient.start, .ConditionColours.Thunderstorm.start)
		XCTAssertEqual(gradient.end, .ConditionColours.Thunderstorm.end)
	}

	func testGradient_whenFog_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.fog

		// When
		let gradient = condition.gradient

		// Then
		XCTAssertEqual(gradient.start, .ConditionColours.Fog.start)
		XCTAssertEqual(gradient.end, .ConditionColours.Fog.end)
	}

	func testGradient_whenUnknown_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.unknown

		// When
		let gradient = condition.gradient

		// Then
		XCTAssertEqual(gradient.start, .ConditionColours.Fog.start)
		XCTAssertEqual(gradient.end, .ConditionColours.Fog.end)
	}

	// MARK: - accent tests
	func testAccent_whenClearDay_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.clearDay

		// When
		let accent = condition.accent

		// Then
		XCTAssertEqual(accent, .ConditionColours.ClearDay.accent)
	}

	func testAccent_whenClearNight_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.clearNight

		// When
		let accent = condition.accent

		// Then
		XCTAssertEqual(accent, .ConditionColours.ClearNight.accent)
	}

	func testAccent_whenCloudy_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.cloudy

		// When
		let accent = condition.accent

		// Then
		XCTAssertEqual(accent, .ConditionColours.Cloudy.accent)
	}

	func testAccent_whenRain_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.rain

		// When
		let accent = condition.accent

		// Then
		XCTAssertEqual(accent, .ConditionColours.Rain.accent)
	}

	func testAccent_whenSnow_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.snow

		// When
		let accent = condition.accent

		// Then
		XCTAssertEqual(accent, .ConditionColours.Snow.accent)
	}

	func testAccent_whenThunderstorm_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.thunderstorm

		// When
		let accent = condition.accent

		// Then
		XCTAssertEqual(accent, .ConditionColours.Thunderstorm.accent)
	}

	func testAccent_whenFog_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.fog

		// When
		let accent = condition.accent

		// Then
		XCTAssertEqual(accent, .ConditionColours.Fog.accent)
	}

	func testAccent_whenUnknown_shouldReturnTheExpectedValue() {
		// Given
		let condition = WeatherCondition.unknown

		// When
		let accent = condition.accent

		// Then
		XCTAssertEqual(accent, .ConditionColours.Fog.accent)
	}
}
