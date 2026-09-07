//
//  APIClient.swift
//  Weather-SwiftUI
//
//  Created by Panagiotis Vakalis on 5/9/26.
//

import Foundation
import CoreLocation

protocol APIClientProtocol {
	func getCurrentWeather(
		at coordinates: CLLocationCoordinate2D
	) async throws -> CurrentWeatherResponse
}

struct APIClient: APIClientProtocol {
	private let urlBuilder: URLBuildable
	private let sessionAdapter: SessionAdaptable
	
	init(
		urlBuilder: URLBuildable = URLBuilder(),
		sessionAdapter: SessionAdaptable = SessionAdapter()
	) {
		self.urlBuilder = urlBuilder
		self.sessionAdapter = sessionAdapter
	}
	
	func getCurrentWeather(
		at coordinates: CLLocationCoordinate2D
	) async throws -> CurrentWeatherResponse {
		let url = urlBuilder.buildForCurrentWeather(at: coordinates)
		let (data, response) = try await sessionAdapter.performRequest(using: url)
		
		guard let httpResponse = response as? HTTPURLResponse else {
			throw NetworkError.nonHTTPResponse
		}
		
		guard (200..<300).contains(httpResponse.statusCode) else {
			throw NetworkError.unacceptableStatusCode(httpResponse.statusCode)
		}
		return try JSONDecoder().decode(CurrentWeatherResponse.self, from: data)
	}
}

extension APIClient {
	enum NetworkError: Error, Equatable {
		case nonHTTPResponse
		case unacceptableStatusCode(Int)
	}
}
