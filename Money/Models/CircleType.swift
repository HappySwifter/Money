//
//  CircleType.swift
//  Money
//
//  Created by Artem on 01.03.2024.
//

import Foundation
import SwiftUI

enum CircleType: Codable {
    case account
    case expense
    case plusButton
    
    var color: Color {
        switch self {
        case .account:
            return .green
        case .expense:
            return .red
        case .plusButton:
            return .purple
        }
    }
    
    var highColor: Color {
        return color.opacity(0.3)
    }
}
