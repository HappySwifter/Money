//
//  MyTransaction.swift
//  Money
//
//  Created by Artem on 06.03.2024.
//

import Foundation
import SwiftData


public typealias MyTransaction = SchemaV1.MyTransaction

extension SchemaV1 {
    @Model
    public final class MyTransaction: Sendable {
        @Attribute(.unique) public let id: UUID
        public var date: Date
        public var isIncome: Bool
        public var source: Account?
        public var destination: Account?
        public var sourceAmount: Double
        public var destinationAmount: Double?
        
//        public var isExpense: Bool {
//            !isIncome && !(destination?.isAccount ?? false)
//        }
//        public var sourceAmountText: String {
//            prettify(val: sourceAmount, fractionLength: 2, currencySymbol: source?.currency?.symbol)
//        }
//        public var destinationAmountText: String {
//            prettify(val: destinationAmount, fractionLength: 2, currencySymbol: destination?.currency?.symbol)
//        }
        
        public init(id: UUID = UUID(),
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
        
//        public func convertAmount(to currency: MyCurrency, rates: ExchangeRate) -> Double {
//            guard let sourceCurrency = source?.currency else {
//                assert(false)
//                return 0
//            }
//           
//            if currency.code == sourceCurrency.code {
//                return sourceAmount
//            } else {
//                if let exchRate = rates.value(for: sourceCurrency.code) {
//                    return sourceAmount / exchRate
//                } else {
//    //                assert(false, "ERROR no rate for code \(sourceCurrency.code)")
//                    return 0
//                }
//            }
//        }
    }
}
//
//private func prettify(val: Double?, fractionLength: Int = 0, currencySymbol: String? = nil) -> String {
//    guard let val = val else { return "" }
//    let formatted = val.formatted(
//        .number
//        .precision(.fractionLength(fractionLength))
//    )
//    if let currencySymbol {
//        return formatted + " " + currencySymbol
//    } else {
//        return formatted
//    }
//}
extension MyTransaction {
    static func predicateFor(period: TransactionPeriodType, calendar: Calendar) -> Predicate<MyTransaction> {
        let strart = period.startDate
        let end = period.endDate
        return #Predicate<MyTransaction> { tran in
            tran.date >= strart &&
            tran.date < end &&
            !tran.isIncome &&
            !(tran.destination?.isAccount ?? false)
        }
    }
}
