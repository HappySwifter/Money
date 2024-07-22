//
//  Color.swift
//  Money
//
//  Created by Artem on 05.03.2024.
//

import Foundation
import SwiftUI

public enum SwiftColor: String, CaseIterable {
    case green,
         mint,
         teal,
         blue,
         indigo,
         purple,
         yellow,
         orange,
         red,
         brown,
         gray,
         black,
         clear
    
    public var value: Color {
        switch self {
        case .purple:
            return .purple
        case .red:
            return .red
        case .blue:
            return .blue
        case .gray:
            return .gray
        case .green:
            return .green
        case .black:
            return .black
        case .brown:
            return .brown
        case .indigo:
            return .indigo
        case .mint:
            return .mint
        case .yellow:
            return .yellow
        case .orange:
            return .orange
        case .teal:
            return .teal
        case .clear:
            return .clear
        }
    }
    
    public var colorWithOpacity: Color {
        value.opacity(0.7)
    }
}
