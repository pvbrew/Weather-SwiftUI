//
//  LocationManager.swift
//  Weather-SwiftUI
//
//  Created by Panagiotis Vakalis on 2/9/26.
//

import Foundation
import CoreLocation
import Combine

final class LocationManager: NSObject, ObservableObject {
	// MARK: - Published properties
	// TODO: Turn them into private(set)
	@Published var lastKnownLocation: CLLocationCoordinate2D?
	@Published var isAuthorisationDenied = false
	@Published var errorAccessingLocation: Error?
	@Published private(set) var isRequestingLocation = false

	// MARK: - Properties
	private var manager: CLLocationManageable
	private var hasRetriedAfterLocationUnknown = false

	// MARK: - Intializers
	init(manager: CLLocationManageable = CLLocationManager()) {
		self.manager = manager
		super.init()
		self.manager.delegate = self
	}
	
	// MARK: - Functions
	/// Reads `authorizationStatus` off the main thread and updates published state
	/// accordingly (see `handle(status:)`). The first read of that property in a
	/// process synchronously blocks on an XPC round-trip to `locationd`, which can
	/// take long enough to freeze the UI if done on the main actor (e.g. from a
	/// `.task` at launch).
	@discardableResult
	func checkLocationAuthorisationAsync() async -> CLAuthorizationStatus {
		let status = await Task.detached(priority: .userInitiated) { [manager] in
			manager.authorizationStatus
		}.value
		handle(status: status)
		return status
	}

	/// Confirms authorisation (see `checkLocationAuthorisationAsync()`) before
	/// requesting a location. Use this from user-initiated actions, such as a
	/// "Get location" button tap, since calling `manager.requestLocation()` directly
	/// silently fails (via `didFailWithError`) when permission isn't granted yet.
	func requestLocationIfAuthorised() async {
		let status = await checkLocationAuthorisationAsync()

		if status == .authorizedAlways || status == .authorizedWhenInUse {
			isRequestingLocation = true
			hasRetriedAfterLocationUnknown = false
			errorAccessingLocation = nil
			manager.requestLocation()
		}
	}

	private func handle(status: CLAuthorizationStatus) {
		switch status {
		case .authorizedAlways, .authorizedWhenInUse:
			isAuthorisationDenied = false
		case .denied, .restricted:
			isAuthorisationDenied = true
		case .notDetermined:
			manager.requestWhenInUseAuthorization()
		@unknown default:
			break
		}
	}
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		handle(status: self.manager.authorizationStatus)
	}
	
	func locationManager(
		_ manager: CLLocationManager,
		didUpdateLocations locations: [CLLocation]
	) {
		isRequestingLocation = false
		lastKnownLocation = locations.first?.coordinate
	}

	func locationManager(
		_ manager: CLLocationManager,
		didFailWithError error: Error
	) {
		// `.locationUnknown` means CoreLocation couldn't get a fix yet, not that
		// it never will - retry once before surfacing an error to the user.
		if let clError = error as? CLError,
		   clError.code == .locationUnknown,
		   !hasRetriedAfterLocationUnknown {
			hasRetriedAfterLocationUnknown = true
			self.manager.requestLocation()
			return
		}

		isRequestingLocation = false
		errorAccessingLocation = error
	}
}
