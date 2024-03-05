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
    let id: UUID
    let date: Date
    let name: String
    let icon: String
    let amount: Double
    let currency: Currency?
    let type: CircleType
    let color: String
    
    init(id: UUID = UUID(),
         date: Date = Date(),
         name: String,
         icon: String = "",
         amount: Double = 0.0,
         currency: Currency?,
         type: CircleType,
         color: SwiftColor)
    {
        self.id = id
        self.date = date
        self.name = name
        self.currency = currency
        self.icon = icon
        self.amount = amount
        self.type = type
        self.color = color.rawValue
    }
}
