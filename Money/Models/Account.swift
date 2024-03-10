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
    var amount: Double
    var currencyCode: String
    var currencyName: String
    var currencySymbol: String
    var color: String
    
    init(id: UUID = UUID(),
         orderIndex: Int,
        date: Date = Date(),
        name: String,
         icon: String = "",
         amount: Double = 0.0,
         currencyCode: String,
         currencyName: String,
         currencySymbol: String,
         color: SwiftColor)
    {
        self.id = id
        self.orderIndex = orderIndex
        self.date = date
        self.name = name
        self.currencyCode = currencyCode
        self.currencyName = currencyName
        self.currencySymbol = currencySymbol
        self.icon = icon
        self.amount = amount
        self.color = color.rawValue
    }
}

extension Account : CurrencyConvertible {}

extension Account: Transactionable {
    var type: ItemType {
        .account(id: id)
    }
    
    func deposit(amount: Double) {
        self.amount += amount
    }
    
    func credit(amount: Double) -> Bool {
        if self.amount > amount {
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
