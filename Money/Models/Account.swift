//
//  Account.swift
//  Money
//
//  Created by Artem on 01.03.2024.
//

import Foundation
import SwiftUI
import SwiftData

struct AccountDetails: Codable {
    var amount: Double
    var currency: MyCurrency?
}

@Model
final class Account {
    let id: UUID
    var orderIndex: Int
    let date: Date
    var name: String
    var icon: String
    var color: String

    let isAccount: Bool
    var accountDetails: AccountDetails?
    
    init(id: UUID = UUID(),
         orderIndex: Int,
         date: Date = Date(),
         name: String,
         icon: String = "",
         color: SwiftColor,
         isAccount: Bool,
         accountDetails: AccountDetails?)
    {
        self.id = id
        self.orderIndex = orderIndex
        self.date = date
        self.name = name
        self.icon = icon
//        self.amount = amount
        self.color = color.rawValue
        
        self.isAccount = isAccount
        
        self.accountDetails = accountDetails
    }
    
    func isSameType(with acc: Account) -> Bool {
        if self.isAccount && acc.isAccount {
            return true
        } else if !self.isAccount && !acc.isAccount {
            return true
        } else {
            return false
        }
    }
}

extension Account : CurrencyConvertible {}

extension Account {
    func deposit(amount: Double) {
        self.accountDetails!.amount += amount
    }
    
    func credit(amount: Double) -> Bool {
        if self.accountDetails!.amount >= amount {
            self.accountDetails!.amount -= amount
            return true
        } else {
            return false
        }
    }
}

extension [Account] {
    func updateOrderIndices() {
        for (index, item) in enumerated() {
            item.orderIndex = index
        }
    }
}
