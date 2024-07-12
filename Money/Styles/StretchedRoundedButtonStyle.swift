//
//  StretchedRoundedButton.swift
//  Money
//
//  Created by Artem on 11.07.2024.
//
import SwiftUI

struct StretchedRoundedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        DoneButton(configuration: configuration)
    }
    
    struct DoneButton: View {
        let configuration: Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        
        var body: some View {
            configuration.label
                .padding(.vertical, 15)
                .padding(.horizontal, 15)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(isEnabled ? Color(configuration.isPressed ? .green.opacity(0.7) : .green) : .gray.opacity(0.7))
                .clipShape(Capsule())
                .cornerRadius(10)
                .disabled(true)
        }
    }
}
