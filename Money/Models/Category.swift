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
    let date: Date
    var name: String
    var icon: String
    var color: String
    
    init(date: Date = Date(),
         name: String,
         icon: String,
         color: SwiftColor) {
        self.date = date
        self.name = name
        self.icon = icon
        self.color = color.rawValue
    }
}

extension SpendCategory: Transactionable {
    var type: ItemType {
        .category
    }
    
    func deposit(amount: Double) {
        
    }
    
    func creadit(amount: Double) {
        
    }
}
