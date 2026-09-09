//
//  LocationManager.swift
//  Weather-SwiftUI
//
//  Created by Panagiotis Vakalis on 2/9/26.
//

import Foundation
import CoreLocation
import Combine

@MainActor
final class LocationManager: NSObject, ObservableObject {
	@Published private(set) var lastKnownLocation: CLLocationCoordinate2D?
	@Published var isAuthorisationDenied = false
	@Published private(set) var errorAccessingLocation: Error?
	@Published private(set) var isRequestingLocation = false
	
	private var manager: CLLocationManageable
	private var hasRetriedAfterLocationUnknown = false
	private var isWaitingForAuthorisationToRequestLocation = false
	
	init(manager: CLLocationManageable = CLLocationManager()) {
		self.manager = manager
		super.init()
		self.manager.delegate = self
	}
	
	/// Requests a location if authorised, prompting for authorisation first if it
	/// hasn't been decided yet, since calling `manager.requestLocation()` directly
	/// silently fails (via `didFailWithError`) when permission isn't granted.
	func requestLocationOrAuthorise() async {
		let status = manager.authorizationStatus
		handle(status: status)

		if status == .authorizedAlways || status == .authorizedWhenInUse {
			requestLocation()
		} else if status == .notDetermined {
			isWaitingForAuthorisationToRequestLocation = true
		}
	}

	private func requestLocation() {
		isRequestingLocation = true
		hasRetriedAfterLocationUnknown = false
		errorAccessingLocation = nil
		manager.requestLocation()
	}

	private func handle(status: CLAuthorizationStatus) {
		switch status {
		case .authorizedAlways, .authorizedWhenInUse:
			isAuthorisationDenied = false
			if isWaitingForAuthorisationToRequestLocation {
				isWaitingForAuthorisationToRequestLocation = false
				requestLocation()
			}
		case .denied, .restricted:
			isAuthorisationDenied = true
			isWaitingForAuthorisationToRequestLocation = false
		case .notDetermined:
			manager.requestWhenInUseAuthorization()
		@unknown default:
			break
		}
	}
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: @preconcurrency CLLocationManagerDelegate {
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
