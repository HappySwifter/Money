//
//  Color.swift
//  Money
//
//  Created by Artem on 05.03.2024.
//

import Foundation
import SwiftUI

public enum SwiftColor: String {
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
         clear,
    
         lavender,
         mintCream,
         lightSand,
         smokeBlue,
         powderPink
    
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
        case .black:
            return .black
        case .clear:
            return .clear
        case .lavender, .mintCream, .lightSand, .smokeBlue, .powderPink:
            return Color(rawValue)
        }
    }
    
    public var colorWithOpacity: Color {
        value.opacity(0.7)
    }
    
    public static var accountColors: [SwiftColor] {
        [.lavender, .mintCream, .lightSand, .smokeBlue, .powderPink]
    }
    
    public static var categoryColors: [SwiftColor] {
        [.green, .mint, .teal, .blue, .indigo, .purple, .yellow, .orange, .red, .brown, .gray, .clear]
    }
}
