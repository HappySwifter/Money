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
    case category
    case plusButton
    
    var description: String {
        switch self {
        case .account:
            return "account"
        case .category:
            return "category"
        case .plusButton:
            return ""
        }
    }
    
    var isMovable: Bool {
        switch self {
        case .account, .plusButton:
            return true
        case .category:
            return false
        }
    }
    
    var color: Color {
        switch self {
        case .account:
            return .green
        case .category:
            return .red
        case .plusButton:
            return .purple
        }
    }
    
    var highColor: Color {
        return color.opacity(0.3)
    }
}
