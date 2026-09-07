//
//  MockURLBuilder.swift
//  Weather-SwiftUITests
//
//  Created by Panagiotis Vakalis on 7/9/26.
//

import Foundation
import CoreLocation
@testable import Weather_SwiftUI

final class MockURLBuilder: URLBuildable {
	private(set) var coordinatesReceived: CLLocationCoordinate2D?
	
	func buildForCurrentWeather(at coordinates: CLLocationCoordinate2D) -> URL {
		coordinatesReceived = coordinates
		return URL(string: "https://mock.url")!
	}
}
