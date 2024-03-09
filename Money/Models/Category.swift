//
//  Category.swift
//  Money
//
//  Created by Artem on 06.03.2024.
//

import Foundation
import SwiftData

@Model
class SpendCategory {
    let id: UUID
    let date: Date
    var name: String
    var icon: String
    var color: String
    
    init(id: UUID = UUID(),
        date: Date = Date(),
         name: String,
         icon: String,
         color: SwiftColor) {
        self.id = id
        self.date = date
        self.name = name
        self.icon = icon
        self.color = color.rawValue
    }
}

extension SpendCategory: Transactionable {
    var currencyCode: String {
        assert(false)
        return ""
    }
    
    var type: ItemType {
        .category(id: id)
    }
    
    func deposit(amount: Double, from account: Transactionable) {
        assert(false, "Cant deposit to category")
    }
    
    func credit(amount: Double, to item: Transactionable) {
        assert(false, "Cant creadit from category")
    }
}
