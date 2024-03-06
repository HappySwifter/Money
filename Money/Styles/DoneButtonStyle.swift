//
//  DoneButton.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import SwiftUI

struct DoneButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        DoneButton(configuration: configuration)
    }
    
    struct DoneButton: View {
        let configuration: Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        
        var body: some View {
            configuration.label
                .padding(10)
                .font(.headline)
                .foregroundColor(.white)
                .background(isEnabled ? Color.blue.opacity(0.8) : Color.gray.opacity(0.5))
                .clipShape(Capsule())
                .cornerRadius(10)
                .disabled(true)
        }
    }
}
