//
//  Weather_SwiftUIApp.swift
//  Weather-SwiftUI
//
//  Created by Panagiotis Vakalis on 31/8/26.
//

import SwiftUI

@main
struct Weather_SwiftUIApp: App {
	private var apiClient = APIClient()
	
    var body: some Scene {
        WindowGroup {
            WeatherView()
				.environmentObject(WeatherAggregateModel(apiClient: apiClient))
        }
    }
}
