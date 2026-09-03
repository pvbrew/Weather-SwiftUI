//
//  ContentView.swift
//  Weather-SwiftUI
//
//  Created by Panagiotis Vakalis on 31/8/26.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
	@StateObject private var locationManager = LocationManager()
	
    var body: some View {
		VStack {
			if let coordinate = locationManager.lastKnownLocation {
				Text("Latitude: \(coordinate.latitude)")
				
				Text("Longitude: \(coordinate.longitude)")
			} else {
				Text("Unknown Location")
			}
			
			
			Button("Get location") {
				locationManager.checkLocationAuthorisation()
			}
			.buttonStyle(.borderedProminent)
		}
		.padding()
		.alert("Location Access Denied", isPresented: $locationManager.isAuthorisationDenied) {
			Button("Cancel", role: .cancel) {}
			Button("Open Settings") {
				if let url = URL(string: UIApplication.openSettingsURLString) {
					UIApplication.shared.open(url)
				}
			}
		} message: {
			Text("Weather-SwiftUI needs access to your location to show local weather. Enable it in Settings.")
		}
    }
}

#Preview {
    ContentView()
}
