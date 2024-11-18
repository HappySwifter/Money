//
//  LoadingView.swift
//  Money
//
//  Created by Artem on 16.11.2024.
//

import SwiftUI

struct LoadingView: View {
    let title: String

    var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .padding(.bottom)
        Text(title)
    }
}

#Preview {
    LoadingView(title: "Hello world")
}
