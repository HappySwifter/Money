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
    var date: Date
    var isIncome: Bool
    var source: Account?
    var destination: Account?
    var sourceAmount: Double
    var destinationAmount: Double?
    
    var isExpense: Bool {
        !isIncome && !(destination?.isAccount ?? false)
    }
    var sourceAmountText: String {
        prettify(val: sourceAmount, fractionLength: 2, currencySymbol: source?.currency?.symbol)
    }
    var destinationAmountText: String {
        prettify(val: destinationAmount, fractionLength: 2, currencySymbol: destination?.currency?.symbol)
    }
    
    init(id: UUID = UUID(),
         date: Date = Date(),
         isIncome: Bool,
         sourceAmount: Double,
         source: Account?,
         destinationAmount: Double?,
         destination: Account?) 
    {
        self.id = id
//        let date = Calendar.current.date(byAdding: .year, value: -1, to: date)!
        self.date = date
        self.isIncome = isIncome
        self.sourceAmount = sourceAmount
        self.source = source
        self.destinationAmount = destinationAmount
        self.destination = destination
    }
    
    func convertAmount(to currency: MyCurrency, rates: ExchangeRate) -> Double {
        guard let sourceCurrency = source?.currency else { assert(false) }
       
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

extension Transaction {
    static func predicateFor(period: TransactionPeriodType, calendar: Calendar) -> Predicate<Transaction> {
        let strart = period.startDate
        let end = period.endDate
        return #Predicate<Transaction> { tran in
            tran.date >= strart &&
            tran.date < end &&
            !tran.isIncome &&
            !(tran.destination?.isAccount ?? false)
        }
    }
}
