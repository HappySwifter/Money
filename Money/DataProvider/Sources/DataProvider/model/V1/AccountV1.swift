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
        public let id: UUID
        public private(set) var orderIndex: Int
        public let date: Date
        public var name: String
        public var color: String
        public var isAccount: Bool
        public var hid: Bool
        public private(set) var amount: Double
        private var iconName: String?
        private var iconColor: String?
        private var iconIsMulticolor: Bool
        public var currency: MyCurrency?
      
        public init(id: UUID = UUID(),
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
            self.hid = false
            self.amount = amount
            self.iconName = nil
            self.iconColor = nil
            self.iconIsMulticolor = false
        }
        
        public var icon: Icon? {
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
    
    public func credit(amount: Double) -> Bool {
        guard isAccount else { return false }
        if self.amount >= amount {
            self.amount -= amount
            return true
        } else {
            return false
        }
    }
}
