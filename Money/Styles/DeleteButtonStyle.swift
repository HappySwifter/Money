//
//  DeleteButtonStyle.swift
//  Money
//
//  Created by Artem on 03.03.2024.
//

import SwiftUI

struct DeleteButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(15)
            .font(.headline)
            .foregroundColor(.white)
            .background(Color.red)
            .clipShape(Capsule())
            .cornerRadius(10)
    }
}

