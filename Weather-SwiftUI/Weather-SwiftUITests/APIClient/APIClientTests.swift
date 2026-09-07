//
//  APIClientTests.swift
//  Weather-SwiftUITests
//
//  Created by Panagiotis Vakalis on 5/9/26.
//

import XCTest
import CoreLocation
@testable import Weather_SwiftUI

final class APIClientTests: XCTestCase {
	// MARK: - Properties
	private var mockCurrentWeatherResponse: CurrentWeatherResponse {
		try! decode(CurrentWeatherResponse.self, from: "current_weather")
	}
	private let coordinates = CLLocationCoordinate2D(
		latitude: 0.0,
		longitude: 0.0
	)
	private let mockURLBuilder = MockURLBuilder()

	// MARK: - getCurrentWeather(at:) tests
	func testAPIClient_whenGettingCurrentWeather_shouldReturnCurrentWeatherResponseObject() async throws {
		// Given
		let sessionAdapter = MockSessionAdapter(
			data: try dataFrom(model: mockCurrentWeatherResponse),
			urlResponse: makeHTTPURLResponse(),
			error: nil
		)
		let sut = makeSut(withSessionAdapter: sessionAdapter)

		// When
		let currentWeatherResponse = try await sut.getCurrentWeather(
			at: coordinates
		)

		// Then
		XCTAssertNotNil(currentWeatherResponse)
	}
	
	func testAPIClient_whenGettingCurrentWeather_theCoordinatesShouldBePropagatedToURLBuilder() async throws {
		// Given
		let sessionAdapter = MockSessionAdapter(
			data: try dataFrom(model: mockCurrentWeatherResponse),
			urlResponse: makeHTTPURLResponse(),
			error: nil
		)
		let sut = makeSut(withSessionAdapter: sessionAdapter)
		
		// When
		let currentWeatherResponse = try await sut.getCurrentWeather(
			at: coordinates
		)
		
		// Then
		XCTAssertEqual(
			mockURLBuilder.coordinatesReceived?.latitude,
			coordinates.latitude
		)
		XCTAssertEqual(
			mockURLBuilder.coordinatesReceived?.longitude,
			coordinates.longitude
		)
	}

	func testAPIClient_whenStatusCodeIsUnacceptable_shouldThrowUnacceptableStatusCodeError() async throws {
		// Given
		let sessionAdapter = MockSessionAdapter(
			data: try dataFrom(model: mockCurrentWeatherResponse),
			urlResponse: makeHTTPURLResponse(withStatusCode: 300),
			error: nil
		)
		let sut = makeSut(withSessionAdapter: sessionAdapter)

		// When Then
		await assertThrowsAsyncError(
			try await sut.getCurrentWeather(
				at: coordinates
			)
		) { error in
			XCTAssertEqual(error as? APIClient.NetworkError, .unacceptableStatusCode(300))
		}
	}

	func testAPIClient_whenSessionAdapterThrows_shouldPropagateError() async throws {
		// Given
		let sessionAdapter = MockSessionAdapter(
			data: try dataFrom(model: mockCurrentWeatherResponse),
			urlResponse: makeHTTPURLResponse(),
			error: NSError(domain: "domain", code: 1)
		)
		let sut = makeSut(withSessionAdapter: sessionAdapter)

		// When Then
		await assertThrowsAsyncError(
			try await sut.getCurrentWeather(
				at: coordinates
			)
		) { error in
			XCTAssertEqual((error as NSError).domain, "domain")
		}
	}

	func testAPIClient_whenResponseIsNotHTTP_shouldThrowNonHTTPResponseError() async throws {
		// Given
		let sessionAdapter = MockSessionAdapter(
			data: try dataFrom(model: mockCurrentWeatherResponse),
			urlResponse: URLResponse(
				url: URL(string: "https://www.apple.com")!,
				mimeType: nil,
				expectedContentLength: 0,
				textEncodingName: nil
			),
			error: nil
		)
		let sut = makeSut(withSessionAdapter: sessionAdapter)

		// When Then
		await assertThrowsAsyncError(
			try await sut.getCurrentWeather(
				at: coordinates
			)
		) { error in
			XCTAssertEqual(error as? APIClient.NetworkError, .nonHTTPResponse)
		}
	}

	func testAPIClient_whenResponseDataIsNotDecodable_shouldThrowDecodingError() async throws {
		// Given
		let sessionAdapter = MockSessionAdapter(
			data: Data("not valid json".utf8),
			urlResponse: makeHTTPURLResponse(),
			error: nil
		)
		let sut = makeSut(withSessionAdapter: sessionAdapter)

		// When Then
		await assertThrowsAsyncError(
			try await sut.getCurrentWeather(at: coordinates)
		) { error in
			XCTAssertTrue(error is DecodingError)
		}
	}

	// MARK: - Helper functions
	private func makeSut(
		withSessionAdapter sessionAdapter: MockSessionAdapter
	) -> APIClient {
		APIClient(urlBuilder: mockURLBuilder, sessionAdapter: sessionAdapter)
	}

	private func makeHTTPURLResponse(
		withStatusCode statusCode: Int = 200
	) -> HTTPURLResponse {
		HTTPURLResponse(
			url: URL(string: "https://www.apple.com")!,
			statusCode: statusCode,
			httpVersion: nil,
			headerFields: nil
		)!
	}

	private func dataFrom<T: Encodable>(model: T) throws -> Data {
		try JSONEncoder().encode(model)
	}
}
