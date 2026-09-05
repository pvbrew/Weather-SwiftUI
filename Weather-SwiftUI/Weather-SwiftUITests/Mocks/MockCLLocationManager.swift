//
//  MockCLLocationManager.swift
//  Weather-SwiftUITests
//
//  Created by Panagiotis Vakalis on 2/9/26.
//

import Foundation
import CoreLocation
@testable import Weather_SwiftUI

final class MockCLLocationManager: CLLocationManageable {
	// MARK: - Properties
	var delegate: CLLocationManagerDelegate?
	var authorizationStatus: CLAuthorizationStatus = .notDetermined
	var location: CLLocation?
	var hasRequestedWhenInUseAuthorization = false
	
	// MARK: - Functions
	func requestWhenInUseAuthorization() {
		hasRequestedWhenInUseAuthorization = true
	}
	
	func requestLocation() {
		location = CLLocation(latitude: 37.7749, longitude: -122.4194)
	}
}
