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
    var icon: String
    var color: String
    var isAccount: Bool
    var isHidden: Bool
    private(set) var amount: Double
    var currency: MyCurrency?
    
    init(id: UUID = UUID(),
         orderIndex: Int,
         date: Date = Date(),
         name: String,
         icon: String,
         color: SwiftColor,
         isAccount: Bool,
         isHidden: Bool = false,
         amount: Double)
    {
        self.id = id
        self.orderIndex = orderIndex
        self.date = date
        self.name = name
        self.icon = icon
        self.color = color.rawValue
        self.isAccount = isAccount
        self.isHidden = isHidden
        self.amount = amount
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
             $0.isAccount/* && !$0.isHidden*/ // if uncomment then its freezes
        }
    }
    
    static func categoryPredicate() -> Predicate<Account> {
        return #Predicate<Account> {
             !$0.isAccount && !$0.isHidden
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
