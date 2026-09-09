//
//  CurrentWeatherMapper.swift
//  Weather-SwiftUI
//
//  Created by Panagiotis Vakalis on 8/9/26.
//

import Foundation

protocol CurrentWeatherMappable {
	static func map(weather: CurrentWeatherResponse) -> CurrentWeather
}

struct CurrentWeatherMapper: CurrentWeatherMappable {
	static func map(weather: CurrentWeatherResponse) -> CurrentWeather {
		let temperature: String
		
		if
			let temperatureValue = weather.values?.temperature,
			let temperatureUnit = weather.units?.temperature {
			temperature = "\(temperatureValue)\(temperatureUnit)"
		} else {
			temperature = "--"
		}
		
		return CurrentWeather(
			temperature: temperature,
			weatherCondition: WeatherConditionMapper.map(
				weatherCode: weather.values?.weatherCode ?? -1,
				isDay: (weather.values?.isDay ?? 1) == 1
			)
		)
	}
}
