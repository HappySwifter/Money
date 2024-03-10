//
//  Transactionable.swift
//  Money
//
//  Created by Artem on 06.03.2024.
//

import Foundation

protocol Transactionable {
    var id: UUID { get }
    var name: String { get }
    var color: String { get }
    var icon: String { get }
    var currencyCode: String { get }
    var type: ItemType { get }
    func deposit(amount: Double)
    func credit(amount: Double) -> Bool
}

enum ItemType: Codable {
    case account(id: UUID)
    case category(id: UUID)
    
    func isSameType(with type: ItemType) -> Bool {
        switch (self, type) {
        case (.account, .account):
            return true
        case (.category, .category):
            return true
        default:
            return false
        }
    }
    
    var isAccount: Bool {
        switch self {
        case .account:
            return true
        case .category:
            return false
        }
    }
    
    var isCategory: Bool {
        switch self {
        case .account:
            return false
        case .category:
            return true
        }
    }
}
