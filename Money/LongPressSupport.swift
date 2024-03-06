//
//  LongPressSupport.swift
//  Money
//
//  Created by Artem on 06.03.2024.
//

import Foundation
import SwiftUI

struct SupportsLongPress: PrimitiveButtonStyle {
    let longPressAction: () -> ()
    @State var isPressed: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(self.isPressed ? 0.9 : 1.0)
            .opacity(self.isPressed ? 0.7 : 1)
            .onTapGesture {
                configuration.trigger()
            }
            .onLongPressGesture(
                perform: {
                    self.longPressAction()
                },
                onPressingChanged: { pressing in
                    self.isPressed = pressing
                }
            )
    }
    
}

struct SupportsLongPressModifier: ViewModifier {
    let longPressAction: () -> ()
    func body(content: Content) -> some View {
        content.buttonStyle(SupportsLongPress(longPressAction: self.longPressAction))
    }
}

extension View {
    func supportsLongPress(longPressAction: @escaping () -> ()) -> some View {
        modifier(SupportsLongPressModifier(longPressAction: longPressAction))
    }
}
