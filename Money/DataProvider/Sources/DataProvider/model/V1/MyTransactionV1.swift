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
    }
}

public enum TransactionType {
    case income, betweenAccounts, spending, unknown
}

extension MyTransaction {
    public var type: TransactionType {
        if isIncome { return .income }
        guard let destination else { return .unknown }
        return destination.isAccount ? .betweenAccounts : .spending
    }
}

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
