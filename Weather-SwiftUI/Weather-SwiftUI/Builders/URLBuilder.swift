//
//  URLBuilder.swift
//  Weather-SwiftUI
//
//  Created by Panagiotis Vakalis on 5/9/26.
//

import Foundation
import CoreLocation

protocol URLBuildable {
	func buildForCurrentWeather(at coordinates: CLLocationCoordinate2D) -> URL
}

struct URLBuilder: URLBuildable {
	func buildForCurrentWeather(at coordinates: CLLocationCoordinate2D) -> URL {
		var components = URLComponents()
		components.scheme = "https"
		components.host = "api.open-meteo.com"
		components.path = "/v1/forecast"
		components.queryItems = [
			URLQueryItem(name: "latitude", value: "\(coordinates.latitude)"),
			URLQueryItem(name: "longitude", value: "\(coordinates.longitude)"),
			URLQueryItem(
				name: "current",
				value: "temperature_2m,weather_code,is_day"
			),
			URLQueryItem(name: "timezone", value: "auto")
		]
		
		guard let url = components.url else {
			fatalError("Failed to construct URL from components: \(components)")
		}
		return url
	}
}
