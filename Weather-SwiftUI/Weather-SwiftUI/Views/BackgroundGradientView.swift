//
//  BackgroundGradientView.swift
//  Weather-SwiftUI
//
//  Created by Panagiotis Vakalis on 9/9/26.
//

import SwiftUI

struct BackgroundGradientView: View {
	private let startColour: Color
	private let endColour: Color
	
	init(startColour: Color, endColour: Color) {
		self.startColour = startColour
		self.endColour = endColour
	}
	
    var body: some View {
		LinearGradient(
			colors: [startColour, endColour],
			startPoint: .top,
			endPoint: .bottom
		)
		.ignoresSafeArea()
    }
}

#Preview {
	BackgroundGradientView(
		startColour: .ConditionColours.ClearDay.start,
		endColour: .ConditionColours.ClearDay.end
	)
}
