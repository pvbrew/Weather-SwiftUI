//
//  LocationManagerTests.swift
//  Weather-SwiftUITests
//
//  Created by Panagiotis Vakalis on 1/9/26.
//

import XCTest
import CoreLocation
@testable import Weather_SwiftUI

@MainActor
final class LocationManagerTests: XCTestCase {
	// MARK: - locationManagerDidChangeAuthorization(_:) tests
	func testLocationManagerDidChangeAuthorization_whenAuthorised_startsUpdatingLocation() {
		// Given
		let (sut, _) = makeSUT(
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

	func testLocationManagerDidChangeAuthorization_whenDeniedAfterError_clearsErrorAccessingLocation() {
		// Given
		let (sut, mockCLLocationManager) = makeSUT(
			authorisationStatus: .authorizedWhenInUse
		)
		sut.locationManager(
			CLLocationManager(),
			didFailWithError: NSError(domain: "location", code: 0)
		)
		XCTAssertNotNil(sut.errorAccessingLocation)
		mockCLLocationManager.authorizationStatus = .denied

		// When
		sut.locationManagerDidChangeAuthorization(CLLocationManager())

		// Then
		XCTAssertTrue(sut.isAuthorisationDenied)
		XCTAssertNil(sut.errorAccessingLocation)
	}

	func testLocationManagerDidChangeAuthorization_whenAuthorisedAfterBeingDenied_requestsLocation() {
		// Given
		let (sut, mockCLLocationManager) = makeSUT(authorisationStatus: .denied)
		sut.locationManagerDidChangeAuthorization(CLLocationManager())
		XCTAssertTrue(sut.isAuthorisationDenied)
		mockCLLocationManager.authorizationStatus = .authorizedWhenInUse

		// When
		sut.locationManagerDidChangeAuthorization(CLLocationManager())

		// Then
		XCTAssertFalse(sut.isAuthorisationDenied)
		XCTAssertEqual(mockCLLocationManager.requestLocationCallCount, 1)
		XCTAssertTrue(sut.isRequestingLocation)
	}

	func testLocationManagerDidChangeAuthorization_whenAuthorisedWithoutPriorRequest_doesNotRequestLocation() {
		// Given
		let (sut, mockCLLocationManager) = makeSUT(
			authorisationStatus: .authorizedWhenInUse
		)

		// When
		sut.locationManagerDidChangeAuthorization(CLLocationManager())

		// Then
		XCTAssertEqual(mockCLLocationManager.requestLocationCallCount, 0)
	}

	func testLocationManagerDidChangeAuthorization_whenAuthorisedAfterBeingNotDetermined_requestsLocation() async {
		// Given
		let (sut, mockCLLocationManager) = makeSUT(
			authorisationStatus: .notDetermined
		)
		await sut.requestLocationOrAuthorise()
		mockCLLocationManager.authorizationStatus = .authorizedWhenInUse

		// When
		sut.locationManagerDidChangeAuthorization(CLLocationManager())

		// Then
		XCTAssertEqual(mockCLLocationManager.requestLocationCallCount, 1)
		XCTAssertTrue(sut.isRequestingLocation)
	}

	func testLocationManagerDidChangeAuthorization_whenDeniedAfterBeingNotDetermined_doesNotRequestLocation() async {
		// Given
		let (sut, mockCLLocationManager) = makeSUT(
			authorisationStatus: .notDetermined
		)
		await sut.requestLocationOrAuthorise()
		mockCLLocationManager.authorizationStatus = .denied

		// When
		sut.locationManagerDidChangeAuthorization(CLLocationManager())

		// Then
		XCTAssertEqual(mockCLLocationManager.requestLocationCallCount, 0)
		XCTAssertFalse(sut.isRequestingLocation)
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
		await sut.requestLocationOrAuthorise()
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
		await sut.requestLocationOrAuthorise()
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
		await sut.requestLocationOrAuthorise()
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

	// MARK: - requestLocationOrAuthorise() tests
	func testRequestLocationOrAuthorise_whenAuthorisedAlways_requestsLocation() async {
		// Given
		let (sut, mockCLLocationManager) = makeSUT(
			authorisationStatus: .authorizedAlways
		)
		XCTAssertFalse(sut.isRequestingLocation)

		// When
		await sut.requestLocationOrAuthorise()

		// Then
		XCTAssertFalse(sut.isAuthorisationDenied)
		XCTAssertTrue(sut.isRequestingLocation)
		XCTAssertNotNil(mockCLLocationManager.location)
		XCTAssertFalse(mockCLLocationManager.hasRequestedWhenInUseAuthorization)
	}

	func testRequestLocationOrAuthorise_whenAuthorisedWhenInUse_requestsLocation() async {
		// Given
		let (sut, mockCLLocationManager) = makeSUT(
			authorisationStatus: .authorizedWhenInUse
		)

		// When
		await sut.requestLocationOrAuthorise()

		// Then
		XCTAssertFalse(sut.isAuthorisationDenied)
		XCTAssertNotNil(mockCLLocationManager.location)
		XCTAssertFalse(mockCLLocationManager.hasRequestedWhenInUseAuthorization)
	}

	func testRequestLocationOrAuthorise_whenDenied_doesNotRequestLocation() async {
		// Given
		let (sut, mockCLLocationManager) = makeSUT(authorisationStatus: .denied)

		// When
		await sut.requestLocationOrAuthorise()

		// Then
		XCTAssertTrue(sut.isAuthorisationDenied)
		XCTAssertNil(mockCLLocationManager.location)
		XCTAssertFalse(mockCLLocationManager.hasRequestedWhenInUseAuthorization)
	}

	func testRequestLocationOrAuthorise_whenRestricted_doesNotRequestLocation() async {
		// Given
		let (sut, mockCLLocationManager) = makeSUT(
			authorisationStatus: .restricted
		)

		// When
		await sut.requestLocationOrAuthorise()

		// Then
		XCTAssertTrue(sut.isAuthorisationDenied)
		XCTAssertNil(mockCLLocationManager.location)
		XCTAssertFalse(mockCLLocationManager.hasRequestedWhenInUseAuthorization)
	}

	func testRequestLocationOrAuthorise_whenNotDetermined_requestsAuthorisationAndDoesNotRequestLocation() async {
		// Given
		let (sut, mockCLLocationManager) = makeSUT(
			authorisationStatus: .notDetermined
		)

		// When
		await sut.requestLocationOrAuthorise()

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
