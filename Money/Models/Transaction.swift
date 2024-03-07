//
//  Transaction.swift
//  Money
//
//  Created by Artem on 06.03.2024.
//

import Foundation
import SwiftData


@Model
class Transaction {
    let id: UUID
    let date: Date
    let amount: Double
    let sourceId: UUID
    let destination: ItemType
    
    
    init(id: UUID = UUID(),
         date: Date = Date(),
         amount: Double,
         sourceId: UUID,
         destination: ItemType) {
        self.id = id
        self.date = date
        self.amount = amount
        self.sourceId = sourceId
        self.destination = destination
    }
}
