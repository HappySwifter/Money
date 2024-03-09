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
    
    func deposit(amount: Double, from account: Transactionable) {
        self.amount += amount
        let transaction = Transaction(amount: amount,
                                      sourceId: account.id,
                                      destination: self.type)
        modelContext?.insert(transaction)
    }
    
    func credit(amount: Double, to item: Transactionable) {
        self.amount -= amount
        let transaction = Transaction(amount: amount,
                                      sourceId: id,
                                      destination: item.type)
        modelContext?.insert(transaction)
    }
}

extension [Account] {
    func updateOrderIndices() {
        for (index, item) in enumerated() {
            item.orderIndex = index
        }
    }
}
