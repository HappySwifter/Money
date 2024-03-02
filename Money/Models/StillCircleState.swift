//
//  StillCircleState.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import Foundation
import SwiftUI

enum StillCircleState {
    case normal
    case focused
    case disabled
        
    func color(for circleType: CircleType) -> Color {
        switch (self, circleType) {
        case (.normal, .account):
            return circleType.color.opacity(0.8)
        case (.normal, .category):
            return circleType.color.opacity(0.8)
        case (.normal, .plusButton):
            return circleType.color.opacity(0.8)
        case (.normal, .addAccount):
            return circleType.color.opacity(0.8)
        case (.normal, .addCategory):
            return circleType.color.opacity(0.8)
            
        case (.focused, .account):
            return circleType.color
        case (.focused, .category):
            return circleType.color
        case (.focused, .plusButton):
            return circleType.color
        case (.focused, .addAccount):
            return circleType.color
        case (.focused, .addCategory):
            return circleType.color
            
        case (.disabled, .account):
            return circleType.color.opacity(0.3)
        case (.disabled, .category):
            return circleType.color.opacity(0.3)
        case (.disabled, .plusButton):
            return circleType.color.opacity(0.3)
        case (.disabled, .addAccount):
            return circleType.color.opacity(0.3)
        case (.disabled, .addCategory):
            return circleType.color.opacity(0.3)
        }
    }
}
