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
    @Attribute(.unique) let id: UUID
    let date: Date
    let isIncome: Bool
    let source: Account
    let destination: Account
    let sourceAmount: Double
    let destinationAmount: Double?
    
    var isExpense: Bool {
        !isIncome && !destination.isAccount
    }
    
    init(id: UUID = UUID(),
         date: Date = Date(),
         isIncome: Bool,
         sourceAmount: Double,
         source: Account,
         destinationAmount: Double?,
         destination: Account) 
    {
        self.id = id
        self.date = date
        self.isIncome = isIncome
        self.sourceAmount = sourceAmount
        self.source = source
        self.destinationAmount = destinationAmount
        self.destination = destination
    }
    
    func convertAmount(to currency: MyCurrency, rates: ExchangeRate) -> Double {
        guard let sourceCurrency = source.currency else { assert(false) }
       
        if currency.code == sourceCurrency.code {
            return sourceAmount
        } else {
            if let exchRate = rates.value(for: sourceCurrency.code) {
                return sourceAmount / exchRate
            } else {
                assert(false, "ERROR no rate for code \(sourceCurrency.code)")
                return 0
            }
        }
    }
}

//extension Transaction {
//    
//    static func todayPredicate() -> Predicate<Transaction> {
//        let today = Calendar.current.startOfDay(for: Date())
//        
//        return #Predicate<Transaction> { tran in
//            return tran.date >= today && !tran.isIncome
//        }
//    }
//
//    static func thisMonthPredicate() -> Predicate<Transaction> {
//        let comp = Calendar.current
//            .dateComponents([.year, .month], from: Date())
//        let startOfMonth = Calendar.current.date(from: comp)!
//        
//        return #Predicate<Transaction> { tran in
//            return tran.date >= startOfMonth && !tran.isIncome
//        }
//    }
//}
