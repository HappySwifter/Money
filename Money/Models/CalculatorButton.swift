//
//  CalculatorButton.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import Foundation
import SwiftUI

enum CalculatorButton: String, CaseIterable {
    case but1 = "1"
    case but2 = "2"
    case but3 = "3"
    case plus = "+"
    case but4 = "4"
    case but5 = "5"
    case but6 = "6"
    case minus = "-"
    case but7 = "7"
    case but8 = "8"
    case but9 = "9"
    case equal = "="
    case comma = ","
    case but0 = "0"
    case remove = "\u{232b}"
    
    var baseColor: Color {
        .white
    }
    
    var borderColor: Color {
        baseColor
    }
    
    var backgroundColor: Color {
        switch self {
        case .plus, .minus, .equal:
            return .orange.opacity(0.8)
        case .comma, .remove:
            return .clear
        default:
            return baseColor
        }
    }
    
    var isCalcButton: Bool {
        switch self {
        case .equal, .plus, .minus:
            return true
        default:
            return false
        }
    }
}
