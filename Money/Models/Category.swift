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
    
    var type: ItemType {
        .category(id: id)
    }
    
    func deposit(amount: Double) {
        assert(false, "Cant deposit to category")
    }
    
    func credit(amount: Double) -> Bool {
        assert(false, "Cant creadit from category")
        return false
    }
    
    var currencySymbol: String {
        ""
    }
    
    var amount: Double {
        0.0
    }
    
    var currencyCode: String {
        return ""
    }
}
