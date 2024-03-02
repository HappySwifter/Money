//
//  DoneButton.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import SwiftUI


struct DoneButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(15)
            .font(.headline)
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(Capsule())
            .cornerRadius(10)
    }
}
