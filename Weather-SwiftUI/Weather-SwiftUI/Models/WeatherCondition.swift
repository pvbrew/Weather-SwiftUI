//
//  WeatherCondition.swift
//  Weather-SwiftUI
//
//  Created by Panagiotis Vakalis on 7/9/26.
//

enum WeatherCondition: Equatable {
	case clearDay
	case clearNight
	case cloudy
	case rain
	case snow
	case thunderstorm
	case fog
	case unknown
	
	var title: String {
		switch self {
		case .clearDay: return "Clear Day"
		case .clearNight: return "Clear Night"
		case .cloudy: return "Cloudy"
		case .rain: return "Rain"
		case .snow: return "Snow"
		case .thunderstorm: return "Thunderstorm"
		case .fog: return "Fog"
		case .unknown: return "--"
		}
	}
	
	var imageName: String {
		switch self {
		case .clearDay: return "sun.max.fill"
		case .clearNight: return "moon.fill"
		case .cloudy: return "cloud.fill"
		case .rain: return "cloud.rain.fill"
		case .snow: return "cloud.snow.fill"
		case .thunderstorm: return "cloud.bolt.fill"
		case .fog: return "cloud.fog.fill"
		case .unknown: return "thermometer.variable"
		}
	}
}
