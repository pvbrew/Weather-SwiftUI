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
	// MARK: - checkLocationAuthorisationAsync() tests
	func testCheckLocationAuthorisationAsync_whenAuthorisedAlways_startsUpdatingLocation() async {
		// Given
		let (sut, mockCLLocationManager) = makeSUT(
			authorisationStatus: .authorizedAlways
		)

		// When
		await sut.checkLocationAuthorisationAsync()

		// Then
		XCTAssertFalse(sut.isAuthorisationDenied)
		XCTAssertFalse(mockCLLocationManager.hasRequestedWhenInUseAuthorization)
	}

	func testCheckLocationAuthorisationAsync_whenAuthorisedWhenInUse_startsUpdatingLocation() async {
		// Given
		let (sut, mockCLLocationManager) = makeSUT(
			authorisationStatus: .authorizedWhenInUse
		)

		// When
		await sut.checkLocationAuthorisationAsync()

		// Then
		XCTAssertFalse(sut.isAuthorisationDenied)
		XCTAssertFalse(mockCLLocationManager.hasRequestedWhenInUseAuthorization)
	}

	func testCheckLocationAuthorisationAsync_whenDenied_setsAuthorisationDeniedAndDoesNotUpdateLocation() async {
		// Given
		let (sut, mockCLLocationManager) = makeSUT(authorisationStatus: .denied)

		// When
		await sut.checkLocationAuthorisationAsync()

		// Then
		XCTAssertTrue(sut.isAuthorisationDenied)
		XCTAssertNil(mockCLLocationManager.location)
		XCTAssertFalse(mockCLLocationManager.hasRequestedWhenInUseAuthorization)
	}

	func testCheckLocationAuthorisationAsync_whenRestricted_setsAuthorisationDeniedAndDoesNotUpdateLocation() async {
		// Given
		let (sut, mockCLLocationManager) = makeSUT(
			authorisationStatus: .restricted
		)

		// When
		await sut.checkLocationAuthorisationAsync()

		// Then
		XCTAssertTrue(sut.isAuthorisationDenied)
		XCTAssertNil(mockCLLocationManager.location)
		XCTAssertFalse(mockCLLocationManager.hasRequestedWhenInUseAuthorization)
	}

	func testCheckLocationAuthorisationAsync_whenNotDetermined_requestsAuthorisationAndDoesNotUpdateLocation() async {
		// Given
		let (sut, mockCLLocationManager) = makeSUT(
			authorisationStatus: .notDetermined
		)

		// When
		await sut.checkLocationAuthorisationAsync()

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

	func testLocationManager_didUpdateLocations_clearsIsRequestingLocation() async {
		// Given
		let (sut, mockCLLocationManager) = makeSUT(
			authorisationStatus: .authorizedWhenInUse
		)
		await sut.requestLocationIfAuthorised()
		XCTAssertTrue(sut.isRequestingLocation)

		// When
		sut.locationManager(
			CLLocationManager(),
			didUpdateLocations: [
				CLLocation(latitude: 37.7749, longitude: -122.4194)
			]
		)

		// Then
		XCTAssertFalse(sut.isRequestingLocation)
		XCTAssertEqual(mockCLLocationManager.requestLocationCallCount, 1)
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
		XCTAssertFalse(sut.isRequestingLocation)
	}

	func testLocationManager_didFailWithLocationUnknown_retriesOnceWithoutSurfacingError() async {
		// Given
		let (sut, mockCLLocationManager) = makeSUT(
			authorisationStatus: .authorizedWhenInUse
		)
		await sut.requestLocationIfAuthorised()
		mockCLLocationManager.requestLocationCallCount = 0

		// When
		sut.locationManager(
			CLLocationManager(),
			didFailWithError: CLError(.locationUnknown)
		)

		// Then
		XCTAssertNil(sut.errorAccessingLocation)
		XCTAssertTrue(sut.isRequestingLocation)
		XCTAssertEqual(mockCLLocationManager.requestLocationCallCount, 1)
	}

	func testLocationManager_didFailWithLocationUnknownTwice_surfacesErrorOnSecondFailure() async {
		// Given
		let (sut, mockCLLocationManager) = makeSUT(
			authorisationStatus: .authorizedWhenInUse
		)
		await sut.requestLocationIfAuthorised()
		mockCLLocationManager.requestLocationCallCount = 0

		// When
		sut.locationManager(
			CLLocationManager(),
			didFailWithError: CLError(.locationUnknown)
		)
		sut.locationManager(
			CLLocationManager(),
			didFailWithError: CLError(.locationUnknown)
		)

		// Then
		XCTAssertNotNil(sut.errorAccessingLocation)
		XCTAssertFalse(sut.isRequestingLocation)
		XCTAssertEqual(mockCLLocationManager.requestLocationCallCount, 1)
	}

	// MARK: - requestLocationIfAuthorised() tests
	func testRequestLocationIfAuthorised_whenAuthorisedAlways_requestsLocation() async {
		// Given
		let (sut, mockCLLocationManager) = makeSUT(
			authorisationStatus: .authorizedAlways
		)
		XCTAssertFalse(sut.isRequestingLocation)

		// When
		await sut.requestLocationIfAuthorised()

		// Then
		XCTAssertFalse(sut.isAuthorisationDenied)
		XCTAssertTrue(sut.isRequestingLocation)
		XCTAssertNotNil(mockCLLocationManager.location)
	}

	func testRequestLocationIfAuthorised_whenAuthorisedWhenInUse_requestsLocation() async {
		// Given
		let (sut, mockCLLocationManager) = makeSUT(
			authorisationStatus: .authorizedWhenInUse
		)

		// When
		await sut.requestLocationIfAuthorised()

		// Then
		XCTAssertFalse(sut.isAuthorisationDenied)
		XCTAssertNotNil(mockCLLocationManager.location)
	}

	func testRequestLocationIfAuthorised_whenDenied_doesNotRequestLocation() async {
		// Given
		let (sut, mockCLLocationManager) = makeSUT(authorisationStatus: .denied)

		// When
		await sut.requestLocationIfAuthorised()

		// Then
		XCTAssertTrue(sut.isAuthorisationDenied)
		XCTAssertNil(mockCLLocationManager.location)
	}

	func testRequestLocationIfAuthorised_whenRestricted_doesNotRequestLocation() async {
		// Given
		let (sut, mockCLLocationManager) = makeSUT(
			authorisationStatus: .restricted
		)

		// When
		await sut.requestLocationIfAuthorised()

		// Then
		XCTAssertTrue(sut.isAuthorisationDenied)
		XCTAssertNil(mockCLLocationManager.location)
	}

	func testRequestLocationIfAuthorised_whenNotDetermined_requestsAuthorisationAndDoesNotRequestLocation() async {
		// Given
		let (sut, mockCLLocationManager) = makeSUT(
			authorisationStatus: .notDetermined
		)

		// When
		await sut.requestLocationIfAuthorised()

		// Then
		XCTAssertFalse(sut.isAuthorisationDenied)
		XCTAssertTrue(mockCLLocationManager.hasRequestedWhenInUseAuthorization)
		XCTAssertNil(mockCLLocationManager.location)
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
