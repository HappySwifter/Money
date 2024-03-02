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
    case addAccount
    case addCategory
    
    var addDescription: String {
        switch self {
        case .addAccount:
            return "Add account"
        case .addCategory:
            return "Add category"
        case .plusButton, .account, .category:
            return ""
        }
    }
    
    var isMovable: Bool {
        switch self {
        case .account, .plusButton:
            return true
        case .category, .addAccount, .addCategory:
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
        case .addAccount, .addCategory:
            return .gray
        }
    }
    
    var highColor: Color {
        return color.opacity(0.3)
    }
    
    func canTrigger(stillItem: CircleItem) -> Bool {
        if self == .plusButton && stillItem.type == .category {
            return false
        } else {
            return true
        }
    }
}
