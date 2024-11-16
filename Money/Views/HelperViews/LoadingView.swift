//
//  LoadingView.swift
//  Money
//
//  Created by Artem on 16.11.2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .padding(.bottom)
        Text("Loading data from iCloud...")
    }
}

#Preview {
    LoadingView()
}
