//
//  PresentingType.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import Foundation

enum PresentingType: Equatable {
    
    static func == (lhs: PresentingType, rhs: PresentingType) -> Bool {
        switch (lhs, rhs) {
        case (.transfer, .transfer):
            return true
        case (.details, .details):
            return true
        case (.addAccount, .addAccount):
            return true
        case (.addCategory, .addCategory):
            return true
        case (.none, .none):
            return true
        default:
            return false
        }
    }
    
    case transfer(source: Account?, destination: Account?)
    case details(item: Account)
    case addAccount
    case addCategory
    case none
    
    var sheetHeightFraction: CGFloat {
        switch self {
        case .transfer:
            return 0.6
        case .details:
            return 0.7
        case .addAccount, .addCategory, .none:
            return 1

        }
    }
}
