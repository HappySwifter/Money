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
    private(set) var orderIndex: Int
    let date: Date
    var name: String
    var color: String
    var isAccount: Bool
    private(set) var amount: Double
    
    private var iconName: String?
    private var iconColor: String?
    private var iconIsMulticolor: Bool

    var currency: MyCurrency?
    
    @Relationship(deleteRule: .cascade, inverse: \Money.Transaction.source) var sources: [Money.Transaction]
    @Relationship(deleteRule: .cascade, inverse: \Money.Transaction.destination) var destinations: [Money.Transaction]
    
    var icon: Icon? {
        get {
            if let iconName, let iconColor {
                return Icon(name: iconName,
                            color: SwiftColor(rawValue: iconColor) ?? .gray,
                            isMulticolor: iconIsMulticolor)
            } else {
                return nil
            }
        }
        set {
            iconName = newValue?.name
            iconColor = newValue?.color.rawValue
            iconIsMulticolor = newValue?.isMulticolor ?? false
        }
    }
    
    init(id: UUID = UUID(),
         orderIndex: Int,
         date: Date = Date(),
         name: String,
         color: SwiftColor,
         isAccount: Bool,
         amount: Double)
    {
        self.id = id
        self.orderIndex = orderIndex
        self.date = date
        self.name = name
        self.color = color.rawValue
        self.isAccount = isAccount
        self.amount = amount
        
        self.iconName = nil
        self.iconColor = nil
        self.iconIsMulticolor = false
        
        self.sources = []
        self.destinations = []
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
    
    static func accountPredicate() -> Predicate<Account> {
        return #Predicate<Account> {
             $0.isAccount
        }
    }
    
    static func categoryPredicate() -> Predicate<Account> {
        return #Predicate<Account> {
             !$0.isAccount
        }
    }
}

extension Account : CurrencyConvertible {}

extension Account {
    func updateOrder(index: Int) {
        orderIndex = index
    }
    
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
