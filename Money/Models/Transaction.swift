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
    
    let sourceAmount: Double
    let source: Account
    let destination: Account
    let destinationAmount: Double?
    
    
    init(id: UUID = UUID(), date: Date = Date(), sourceAmount: Double, source: Account, destinationAmount: Double?, destination: Account) {
        self.id = id
        self.date = date
        self.sourceAmount = sourceAmount
        self.source = source
        self.destinationAmount = destinationAmount
        self.destination = destination
    }
}
