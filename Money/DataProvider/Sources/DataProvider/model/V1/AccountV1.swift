//
//  Account.swift
//  Money
//
//  Created by Artem on 01.03.2024.
//

import Foundation
import SwiftUI
import SwiftData


public typealias Account = SchemaV1.Account

extension SchemaV1 {
    @Model
    public final class Account: Sendable {
        public let id: UUID = UUID()
        public private(set) var orderIndex = 0
        public let date = Date()
        public var name = ""
        public var color = ""
        public var isAccount = true
        public var hid = false
        public private(set) var amount = 0.0
        private var iconName = ""
        private var iconColor = ""
        
        private var currencyCode: String? = ""
        private var currencyName: String? = ""
        private var currencySymbol: String? = ""
                
        @Relationship(inverse: \MyTransaction.source)
        private var sources: [MyTransaction]?
        
        @Relationship(inverse: \MyTransaction.destination)
        private var destinations: [MyTransaction]?
        
        public init(id: UUID = UUID(),
                    orderIndex: Int,
                    date: Date = Date(),
                    name: String,
                    color: String,
                    isAccount: Bool,
                    amount: Double,
                    iconName: String,
                    iconColor: String)
        {
            self.id = id
            self.orderIndex = orderIndex
            self.date = date
            self.name = name
            self.color = color
            self.isAccount = isAccount
            self.hid = false
            self.amount = amount
            self.iconName = iconName
            self.iconColor = iconColor
        }
        
        public var icon: Icon {
            get {
                return Icon(name: iconName, color: SwiftColor(rawValue: iconColor) ?? .gray)
            }
            set {
                iconName = newValue.name
                iconColor = newValue.color.rawValue
            }
        }
        
        public func set(currency: MyCurrency) {
            print("setting cur", currency)
            currencyCode = currency.code
            currencyName = currency.name
            currencySymbol = currency.symbol
        }
        
        public func getCurrency() -> MyCurrency? {
            if let currencyCode, let currencyName {
                return MyCurrency(code: currencyCode, name: currencyName, symbol: currencySymbol)
            } else {
                return nil
            }
        }
    }
}

extension Account {
    public func isSameType(with acc: Account) -> Bool {
        if self.isAccount && acc.isAccount {
            return true
        } else if !self.isAccount && !acc.isAccount {
            return true
        } else {
            return false
        }
    }
    
    public static func accountPredicate() -> Predicate<Account> {
        return #Predicate<Account> {
            $0.isAccount &&
            !$0.hid
        }
    }
    
    public static func categoryPredicate() -> Predicate<Account> {
        return #Predicate<Account> {
            !$0.isAccount &&
            !$0.hid
        }
    }
    
    public static func menuListDestinationAccountPredicate(isAccount: Bool, notId: UUID) -> Predicate<Account> {
        #Predicate<Account> {
            $0.isAccount == isAccount &&
            $0.id != notId &&
            !$0.hid
        }
    }
}

extension Account {
    public func updateOrder(index: Int) {
        orderIndex = index
    }
    
    public func setInitial(amount: Double) {
        self.amount = amount
    }
    
    public func deposit(amount: Double) {
        guard isAccount else { return }
        self.amount += amount
    }
    
    public func canCredit(amount: Double) -> Bool {
        guard isAccount else { return false }
        return self.amount >= amount
    }
    
    public func credit(amount: Double) -> Bool {
        guard isAccount else { return false }
        if canCredit(amount: amount) {
            self.amount -= amount
            return true
        } else {
            return false
        }
    }
}
