//
//  CLLocationManageable.swift
//  Weather-SwiftUI
//
//  Created by Panagiotis Vakalis on 2/9/26.
//

import CoreLocation

protocol CLLocationManageable {
	// MARK: - Properties
	var delegate: CLLocationManagerDelegate? { get set }
	var authorizationStatus: CLAuthorizationStatus { get }
	var location: CLLocation? { get }
	
	// MARK: - Functions
	func requestWhenInUseAuthorization()
	func requestLocation()
}

extension CLLocationManager: CLLocationManageable {}
