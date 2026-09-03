//
//  LocationManagerTests.swift
//  Weather-SwiftUITests
//
//  Created by Panagiotis Vakalis on 1/9/26.
//

import XCTest
import CoreLocation
@testable import Weather_SwiftUI

final class LocationManagerTests: XCTestCase {
	// MARK: - checkLocationAuthorisation() tests
	func testCheckLocationAuthorisation_whenAuthorisedAlways_startsUpdatingLocation() {
		// Given
		let mockCLLocationManager = MockCLLocationManager()
		mockCLLocationManager.authorizationStatus = .authorizedAlways
		let sut = LocationManager(manager: mockCLLocationManager)
		
		// When
		sut.checkLocationAuthorisation()
		
		// Then
		XCTAssertFalse(sut.isAuthorisationDenied)
		XCTAssertEqual(
			mockCLLocationManager.location?.coordinate.latitude,
			37.7749
		)
		XCTAssertEqual(
			mockCLLocationManager.location?.coordinate.longitude,
			-122.4194
		)
		XCTAssertFalse(mockCLLocationManager.hasRequestedWhenInUseAuthorization)
	}
	
	func testCheckLocationAuthorisation_whenAuthorisedWhenInUse_startsUpdatingLocation() {
		// Given
		let mockCLLocationManager = MockCLLocationManager()
		mockCLLocationManager.authorizationStatus = .authorizedWhenInUse
		let sut = LocationManager(manager: mockCLLocationManager)
		
		// When
		sut.checkLocationAuthorisation()
		
		// Then
		XCTAssertFalse(sut.isAuthorisationDenied)
		XCTAssertEqual(
			mockCLLocationManager.location?.coordinate.latitude,
			37.7749
		)
		XCTAssertEqual(
			mockCLLocationManager.location?.coordinate.longitude,
			-122.4194
		)
		XCTAssertFalse(mockCLLocationManager.hasRequestedWhenInUseAuthorization)
	}
	
	func testCheckLocationAuthorisation_whenDenied_setsAuthorisationDeniedAndDoesNotUpdateLocation() {
		// Given
		let mockCLLocationManager = MockCLLocationManager()
		mockCLLocationManager.authorizationStatus = .denied
		let sut = LocationManager(manager: mockCLLocationManager)
		
		// When
		sut.checkLocationAuthorisation()
		
		// Then
		XCTAssertTrue(sut.isAuthorisationDenied)
		XCTAssertNil(mockCLLocationManager.location)
		XCTAssertFalse(mockCLLocationManager.hasRequestedWhenInUseAuthorization)
	}
	
	func testCheckLocationAuthorisation_whenRestricted_setsAuthorisationDeniedAndDoesNotUpdateLocation() {
		// Given
		let mockCLLocationManager = MockCLLocationManager()
		mockCLLocationManager.authorizationStatus = .restricted
		let sut = LocationManager(manager: mockCLLocationManager)
		
		// When
		sut.checkLocationAuthorisation()
		
		// Then
		XCTAssertTrue(sut.isAuthorisationDenied)
		XCTAssertNil(mockCLLocationManager.location)
		XCTAssertFalse(mockCLLocationManager.hasRequestedWhenInUseAuthorization)
	}
	
	func testCheckLocationAuthorisation_whenNotDetermined_requestsAuthorisationAndDoesNotUpdateLocation() {
		// Given
		let mockCLLocationManager = MockCLLocationManager()
		mockCLLocationManager.authorizationStatus = .notDetermined
		let sut = LocationManager(manager: mockCLLocationManager)
		
		// When
		sut.checkLocationAuthorisation()
		
		// Then
		XCTAssertFalse(sut.isAuthorisationDenied)
		XCTAssertNil(mockCLLocationManager.location)
		XCTAssertTrue(mockCLLocationManager.hasRequestedWhenInUseAuthorization)
	}
	
	// MARK: - locationManagerDidChangeAuthorization(_:) tests
	func testLocationManagerDidChangeAuthorization_whenAuthorised_startsUpdatingLocation() {
		// Given
		let mockCLLocationManager = MockCLLocationManager()
		mockCLLocationManager.authorizationStatus = .authorizedWhenInUse
		let sut = LocationManager(manager: mockCLLocationManager)
		
		// When
		sut.locationManagerDidChangeAuthorization(CLLocationManager())
		
		// Then
		XCTAssertFalse(sut.isAuthorisationDenied)
		XCTAssertEqual(
			mockCLLocationManager.location?.coordinate.latitude,
			37.7749
		)
		XCTAssertEqual(
			mockCLLocationManager.location?.coordinate.longitude,
			-122.4194
		)
	}
	
	func testLocationManagerDidChangeAuthorization_whenDenied_setsAuthorisationDenied() {
		// Given
		let mockCLLocationManager = MockCLLocationManager()
		mockCLLocationManager.authorizationStatus = .denied
		let sut = LocationManager(manager: mockCLLocationManager)
		
		// When
		sut.locationManagerDidChangeAuthorization(CLLocationManager())
		
		// Then
		XCTAssertTrue(sut.isAuthorisationDenied)
		XCTAssertNil(mockCLLocationManager.location)
	}
}
