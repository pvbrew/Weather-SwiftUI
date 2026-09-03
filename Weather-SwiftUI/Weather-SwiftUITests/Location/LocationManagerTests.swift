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
		let (sut, mockCLLocationManager) = makeSUT(
			authorisationStatus: .authorizedAlways
		)
		
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
		let (sut, mockCLLocationManager) = makeSUT(
			authorisationStatus: .authorizedWhenInUse
		)
		
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
		let (sut, mockCLLocationManager) = makeSUT(authorisationStatus: .denied)
		
		// When
		sut.checkLocationAuthorisation()
		
		// Then
		XCTAssertTrue(sut.isAuthorisationDenied)
		XCTAssertNil(mockCLLocationManager.location)
		XCTAssertFalse(mockCLLocationManager.hasRequestedWhenInUseAuthorization)
	}
	
	func testCheckLocationAuthorisation_whenRestricted_setsAuthorisationDeniedAndDoesNotUpdateLocation() {
		// Given
		let (sut, mockCLLocationManager) = makeSUT(
			authorisationStatus: .restricted
		)
		
		// When
		sut.checkLocationAuthorisation()
		
		// Then
		XCTAssertTrue(sut.isAuthorisationDenied)
		XCTAssertNil(mockCLLocationManager.location)
		XCTAssertFalse(mockCLLocationManager.hasRequestedWhenInUseAuthorization)
	}
	
	func testCheckLocationAuthorisation_whenNotDetermined_requestsAuthorisationAndDoesNotUpdateLocation() {
		// Given
		let (sut, mockCLLocationManager) = makeSUT(
			authorisationStatus: .notDetermined
		)
		
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
		let (sut, mockCLLocationManager) = makeSUT(
			authorisationStatus: .authorizedWhenInUse
		)
		
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
		let (sut, mockCLLocationManager) = makeSUT(authorisationStatus: .denied)
		
		// When
		sut.locationManagerDidChangeAuthorization(CLLocationManager())
		
		// Then
		XCTAssertTrue(sut.isAuthorisationDenied)
		XCTAssertNil(mockCLLocationManager.location)
	}
	
	// MARK: - locationManager(_:didUpdateLocations:) tests
	func testLocationManager_didUpdateLocations_updatesLocation() {
		// Given
		let (sut, _) = makeSUT(authorisationStatus: .authorizedWhenInUse)
		XCTAssertNil(sut.lastKnownLocation)
		
		// When
		sut.locationManager(
			CLLocationManager(),
			didUpdateLocations: [
				CLLocation(latitude: 37.7749, longitude: -122.4194)
			]
		)
		
		// Then
		XCTAssertEqual(sut.lastKnownLocation?.latitude, 37.7749)
		XCTAssertEqual(sut.lastKnownLocation?.longitude, -122.4194)
	}
	
	// MARK: - locationManager(_:didFailWithError:) tests
	func testLocationManager_didFailWithError_setTheError() throws {
		// Given
		let (sut, _) = makeSUT(authorisationStatus: .authorizedWhenInUse)
		XCTAssertNil(sut.errorAccessingLocation)
		let error = NSError(domain: "location", code: 0)
		
		// When
		sut.locationManager(CLLocationManager(), didFailWithError: error)
		
		// Then
		let errorReceived = try XCTUnwrap(
			sut.errorAccessingLocation as? NSError
		)
		XCTAssertEqual(errorReceived, error)
	}
	
	// MARK: - Helpers
	private func makeSUT(
		authorisationStatus: CLAuthorizationStatus
	) -> (sut: LocationManager, mock: MockCLLocationManager) {
		let mock = MockCLLocationManager()
		mock.authorizationStatus = authorisationStatus
		let sut = LocationManager(manager: mock)
		return (sut, mock)
	}
}
