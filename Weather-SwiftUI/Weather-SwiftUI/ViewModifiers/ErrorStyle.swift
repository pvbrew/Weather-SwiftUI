//
//  ErrorStyle.swift
//  Weather-SwiftUI
//
//  Created by Panagiotis Vakalis on 9/9/26.
//

import Foundation
import SwiftUI

struct ErrorStyle: ViewModifier {
	func body(content: Content) -> some View {
		content
			.foregroundStyle(.errorTextColour)
			.font(Typography.errorText)
	}
}

extension View {
	func errorStyle() -> some View {
		modifier(ErrorStyle())
	}
}
