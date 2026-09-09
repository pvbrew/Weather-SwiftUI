//
//  Shimmer.swift
//  Weather-SwiftUI
//
//  Created by Panagiotis Vakalis on 9/9/26.
//

import SwiftUI

struct Shimmer: ViewModifier {
	@State private var isAnimating = false

	func body(content: Content) -> some View {
		content
			.opacity(0.35)
			.overlay {
				GeometryReader { proxy in
					LinearGradient(
						colors: [.clear, .white, .clear],
						startPoint: .leading,
						endPoint: .trailing
					)
					.frame(width: proxy.size.width)
					.offset(x: isAnimating ? proxy.size.width : -proxy.size.width)
				}
				.mask(content)
			}
			.onAppear {
				withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
					isAnimating = true
				}
			}
	}
}

extension View {
	func shimmering() -> some View {
		modifier(Shimmer())
	}
}
