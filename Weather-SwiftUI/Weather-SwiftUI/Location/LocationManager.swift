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
	@Published var lastKnownLocation: CLLocationCoordinate2D?
	@Published var isAuthorisationDenied = false
	
	// MARK: - Properties
	private var manager: CLLocationManageable
	
	// MARK: - Intializers
	init(manager: CLLocationManageable = CLLocationManager()) {
		self.manager = manager
	}
	
	// MARK: - Functions
	func checkLocationAuthorisation() {
		manager.delegate = self
		manager.startUpdatingLocation()
		
		switch manager.authorizationStatus {
		case .authorizedAlways, .authorizedWhenInUse:
			isAuthorisationDenied = false
			manager.startUpdatingLocation()
			break
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
		checkLocationAuthorisation()
	}
	
	func locationManager(
		_ manager: CLLocationManager,
		didUpdateLocations locations: [CLLocation]
	) {
		lastKnownLocation = locations.first?.coordinate
	}
}
