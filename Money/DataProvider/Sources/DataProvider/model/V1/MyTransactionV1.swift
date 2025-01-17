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
        public let id: UUID = UUID()
        public var date = Date()
        public var isIncome = false
        
        @Relationship(deleteRule: .noAction)
        public var source: Account?
        
        @Relationship(deleteRule: .noAction)
        public var destination: Account?
        public var sourceAmount = 0.0
        public var destinationAmount: Double?
        public var comment: String?
        
        public init(id: UUID = UUID(),
                    date: Date,
                    isIncome: Bool,
                    sourceAmount: Double,
                    source: Account?,
                    destinationAmount: Double?,
                    destination: Account,
                    comment: String?)
        {
            self.id = id
            //        let date = Calendar.current.date(byAdding: .year, value: -1, to: date)!
            self.date = date
            self.isIncome = isIncome
            self.sourceAmount = sourceAmount
            self.source = source
            self.destinationAmount = destinationAmount
            self.destination = destination
            self.comment = comment
        }
    }
}

public enum TransactionType {
    case income, betweenAccounts, spending, unknown
}

extension MyTransaction {
    public var type: TransactionType {
        if isIncome { return .income }
        return (destination?.isAccount ?? false) ? .betweenAccounts : .spending
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
