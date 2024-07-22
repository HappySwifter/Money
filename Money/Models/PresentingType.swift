//
//  PresentingType.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import Foundation
import DataProvider

enum PresentingType: Equatable {
    
    static func == (lhs: PresentingType, rhs: PresentingType) -> Bool {
        switch (lhs, rhs) {
        case (.newIncome, .newIncome):
            return true
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
    
    case newIncome(destination: Account)
    case transfer(source: Account, destination: Account)
    case details(item: Account)
    case addAccount
    case addCategory
    case none
}
