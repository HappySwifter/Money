//
//  Category.swift
//  Money
//
//  Created by Artem on 06.03.2024.
//

import Foundation
import SwiftData

@Model
class Category {
    var name: String
    var icon: String
    var color: String
    
    init(name: String, icon: String, color: String) {
        self.name = name
        self.icon = icon
        self.color = color
    }
}

extension Category: Transactionable {
    func deposit(amount: Double) {
        
    }
    
    func creadit(amount: Double) {
        
    }
}
