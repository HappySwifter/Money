//
//  CircleItem.swift
//  Money
//
//  Created by Artem on 01.03.2024.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class CircleItem {
    var name: String
    var icon: String
    var amount: Double
    var currency: Currency?
    var type: CircleType
    var color: String
    
    init(name: String,
         icon: String = "",
         amount: Double = 0.0,
         currency: Currency?,
         type: CircleType,
         color: SwiftColor)
    {
        self.name = name
        self.currency = currency
        self.icon = icon
        self.amount = amount
        self.type = type
        self.color = color.rawValue
    }
}

extension CircleItem: Transactionable {
    func deposit(amount: Double) {
        
    }
    
    func creadit(amount: Double) {
        
    }
}
