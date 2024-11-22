//
//  BackGradientView.swift
//  Money
//
//  Created by Artem on 22.11.2024.
//

import SwiftUI

struct BackGradientView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color("gradient_0"), Color("gradient_1")]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .ignoresSafeArea()
    }
}

#Preview {
    BackGradientView()
}
