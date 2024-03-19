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
    let isIncome: Bool
    
    let sourceAmount: Double
    let source: Account
    let destination: Account
    let destinationAmount: Double?
    
    
    init(id: UUID = UUID(),
         date: Date = Date(),
         isIncome: Bool,
         sourceAmount: Double,
         source: Account,
         destinationAmount: Double?,
         destination: Account) {
        self.id = id
        self.date = date
        self.isIncome = isIncome
        self.sourceAmount = sourceAmount
        self.source = source
        self.destinationAmount = destinationAmount
        self.destination = destination
    }
    
    var sign: String {
        isIncome ? "+" : "-"
    }
}

extension Transaction {
    
    static func todayPredicate() -> Predicate<Transaction> {
        let today = Calendar.current.startOfDay(for: Date())
        
        return #Predicate<Transaction> { tran in
            return tran.date >= today
        }
    }

    static func thisMonthPredicate() -> Predicate<Transaction> {
        let comp = Calendar.current
            .dateComponents([.year, .month], from: Date())
        let startOfMonth = Calendar.current.date(from: comp)!
        
        return #Predicate<Transaction> { tran in
            return tran.date >= startOfMonth
        }
    }
}
