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
    let date: Date
    var name: String
    var icon: String
    var amount: Double
    var currency: Currency?
    var color: String
    
    init(date: Date = Date(),
        name: String,
         icon: String = "",
         amount: Double = 0.0,
         currency: Currency?,
         color: SwiftColor)
    {
        self.date = date
        self.name = name
        self.currency = currency
        self.icon = icon
        self.amount = amount
        self.color = color.rawValue
    }
}

extension Account: Transactionable {
    var type: ItemType {
        .account
    }
    
    func deposit(amount: Double) {

    }
    
    func creadit(amount: Double) {
        
    }
}
