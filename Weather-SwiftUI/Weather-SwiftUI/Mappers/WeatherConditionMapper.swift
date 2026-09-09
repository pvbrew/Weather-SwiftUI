//
//  WeatherConditionMapper.swift
//  Weather-SwiftUI
//
//  Created by Panagiotis Vakalis on 7/9/26.
//

protocol WeatherConditionMappable {
	static func map(weatherCode: Int, isDay: Bool) -> WeatherCondition
}

struct WeatherConditionMapper: WeatherConditionMappable {
	static func map(weatherCode: Int, isDay: Bool) -> WeatherCondition {
		switch weatherCode {
		case 0, 1:
			return isDay ? .clearDay : .clearNight
		case 2, 3:
			return .cloudy
		case 45, 48:
			return .fog
		case 51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82:
			return .rain
		case 71, 73, 75, 77, 85, 86:
			return .snow
		case 95, 96, 99:
			return .thunderstorm
		default:
			return .unknown
		}
	}
}
