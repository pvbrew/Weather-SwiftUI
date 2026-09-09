//
//  LoadingView.swift
//  Weather-SwiftUI
//
//  Created by Panagiotis Vakalis on 9/9/26.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        Text("Loading...")
			.font(Typography.shimmeringText)
			.foregroundStyle(.textColour)
			.shimmering()
    }
}

#Preview {
    LoadingView()
}
