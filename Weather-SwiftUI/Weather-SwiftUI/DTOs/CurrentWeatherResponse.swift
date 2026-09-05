//
//  CurrentWeatherResponse.swift
//  Weather-SwiftUI
//
//  Created by Panagiotis Vakalis on 4/9/26.
//

import Foundation

struct CurrentWeatherResponse: Decodable {
	let units: Units?
	let values: Values?

	enum CodingKeys: String, CodingKey {
		case units = "current_units"
		case values = "current"
	}
}

extension CurrentWeatherResponse {
	struct Units: Decodable {
		let temperature: String?

		enum CodingKeys: String, CodingKey {
			case temperature = "temperature_2m"
		}
	}
}

extension CurrentWeatherResponse {
	struct Values: Decodable {
		let temperature: Double?
		let weatherCode: Int?
		let isDay: Int?

		enum CodingKeys: String, CodingKey {
			case temperature = "temperature_2m"
			case weatherCode = "weather_code"
			case isDay = "is_day"
		}
	}
}
