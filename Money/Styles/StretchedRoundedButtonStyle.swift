//
//  StretchedRoundedButton.swift
//  Money
//
//  Created by Artem on 11.07.2024.
//
import SwiftUI

struct StretchedRoundedButtonStyle: ButtonStyle {
    let enabledColor: Color
    let disabledColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        DoneButton(configuration: configuration, enabledColor: enabledColor, disabledColor: disabledColor)
    }
    
    struct DoneButton: View {
        let configuration: Configuration
        let enabledColor: Color
        let disabledColor: Color
        @Environment(\.isEnabled) private var isEnabled: Bool
        
        var body: some View {
            configuration.label
                .padding(.vertical, 15)
                .padding(.horizontal, 15)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(isEnabled ? Color(configuration.isPressed ? enabledColor.opacity(0.7) : enabledColor) : disabledColor)
                .cornerRadius(Constants.fieldCornerRadius)
                .disabled(true)
        }
    }
}
