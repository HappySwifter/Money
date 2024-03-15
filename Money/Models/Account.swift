//
//  Account.swift
//  Money
//
//  Created by Artem on 01.03.2024.
//

import Foundation
import SwiftUI
import SwiftData


@Model
final class Account {
    let id: UUID
    var orderIndex: Int
    let date: Date
    var name: String
    var icon: String
    var color: String
    var isAccount: Bool
    private(set) var amount: Double
    var currency: MyCurrency?
    
    init(id: UUID = UUID(),
         orderIndex: Int,
         date: Date = Date(),
         name: String,
         icon: String,
         color: SwiftColor,
         isAccount: Bool,
         amount: Double,
         currency: MyCurrency?)
    {
        self.id = id
        self.orderIndex = orderIndex
        self.date = date
        self.name = name
        self.icon = icon
        self.color = color.rawValue
        self.isAccount = isAccount
        self.amount = amount
        self.currency = currency
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
    
    func setInitial(amount: Double) {
        self.amount = amount
    }
    
    func deposit(amount: Double) {
        guard isAccount else { return }
        self.amount += amount
    }
    
    func credit(amount: Double) -> Bool {
        guard isAccount else { return false }
        if self.amount >= amount {
            self.amount -= amount
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
