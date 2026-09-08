//
//  WeatherCondition.swift
//  Weather-SwiftUI
//
//  Created by Panagiotis Vakalis on 7/9/26.
//

import DeveloperToolsSupport

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

	var gradient: (start: ColorResource, end: ColorResource) {
		switch self {
		case .clearDay:
			return (
				.ConditionColours.ClearDay.start,
				.ConditionColours.ClearDay.end
			)
		case .clearNight:
			return (
				.ConditionColours.ClearNight.start,
				.ConditionColours.ClearNight.end
			)
		case .cloudy:
			return (
				.ConditionColours.Cloudy.start,
				.ConditionColours.Cloudy.end
			)
		case .rain:
			return (
				.ConditionColours.Rain.start,
				.ConditionColours.Rain.end
			)
		case .snow:
			return (
				.ConditionColours.Snow.start,
				.ConditionColours.Snow.end
			)
		case .thunderstorm:
			return (
				.ConditionColours.Thunderstorm.start,
				.ConditionColours.Thunderstorm.end
			)
		case .fog, .unknown:
			return (
				.ConditionColours.Fog.start,
				.ConditionColours.Fog.end
			)
		}
	}

	var accent: ColorResource {
		switch self {
		case .clearDay: return .ConditionColours.ClearDay.accent
		case .clearNight: return .ConditionColours.ClearNight.accent
		case .cloudy: return .ConditionColours.Cloudy.accent
		case .rain: return .ConditionColours.Rain.accent
		case .snow: return .ConditionColours.Snow.accent
		case .thunderstorm: return .ConditionColours.Thunderstorm.accent
		case .fog, .unknown: return .ConditionColours.Fog.accent
		}
	}
}
