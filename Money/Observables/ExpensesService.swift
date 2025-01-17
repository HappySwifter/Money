//
//  SpendingsService.swift
//  Money
//
//  Created by Artem on 18.05.2024.
//

import Foundation
import SwiftUI
import OSLog
import DataProvider

@MainActor
@Observable final class ExpensesService {
    private let logger = Logger(subsystem: "Money", category: #file)
    private let dataHandler: DataHandler
    private let preferences: Preferences
    private let currenciesApi: CurrenciesApi
    private let calculateManager: CalculateManager
    private let calendar = Calendar.current
    
    private(set) var accountsTotalAmount = ""
    private(set) var spentToday = ""
    private(set) var spentThisMonth = ""
    
    init(preferences: Preferences, dataHandler: DataHandler) {
        self.preferences = preferences
        self.dataHandler = dataHandler
        currenciesApi = CurrenciesApi(preferences: preferences)
        calculateManager = CalculateManager(currenciesApi: currenciesApi,
                                            dataHandler: dataHandler)
    }
    
    func calculateSpentAndAccountsTotal() async throws {
        let expenses = try await calculateManager.calculateSpent()
        accountsTotalAmount = expenses.accountsTotalAmount
        spentToday = expenses.spentToday
        spentThisMonth = expenses.spentThisMonth
    }
    
    func calculateAccountsTotal() async throws {
        accountsTotalAmount = try await calculateManager.calculateAccountsTotal()
    }
    
    func getSpendingMonthsAndYears() async throws -> (months: [Date], years: [Date]) {
        let trans = try await dataHandler.getTransactions(with: nil,
                                                          sortBy: nil,
                                                          propertiesToFetch: [\MyTransaction.date],
                                                          offset: 0,
                                                          fetchLimit: 0)
        let datesWithNoTime = trans
            .map { TransactionPeriodType.month(value: $0.date).startDate }
            .uniqued()
            .sorted(by: > )
        
        let availableYears = datesWithNoTime
            .map { TransactionPeriodType.year(value: $0).startDate }
            .uniqued()
            .sorted(by: > )
        
        return (months: datesWithNoTime, years: availableYears)
    }
    
    
    func getExpensesFor(period: TransactionPeriodType) async throws -> [PieChartValue] {
        let logDate = Date()
        let transactions = try await dataHandler.getTransaction(for: period)
        
        let userCur = try await dataHandler.getBaseCurrency()
        let groupedByName = Dictionary(grouping: transactions, by: { $0.destination?.name ?? "" })
        var retVal = [PieChartValue]()
        
        for (name, trans) in groupedByName {
            var totalForName = 0.0
            for tran in trans where tran.type == .spending {
                let rates = try await currenciesApi.getExchangeRateFor(
                    currencyCode: userCur.code,
                    date: tran.date
                )
                totalForName += tran.convertAmount(to: userCur.code, rates: rates)
            }
            if totalForName > 0 {
                retVal.append(PieChartValue(amount: Int(round(totalForName)),
                                            title: name,
                                            color: trans.first?.destination?.icon.color.rawValue ?? "",
                                            data: trans))
            }
        }
        let sorted = retVal.sorted(by: { $0.amount > $1.amount })
        logger.info("getExpenses run time: \(Date().timeIntervalSince(logDate))")
        return sorted
    }
    
    func getTodayExchangeRateFor(currencyCode: String) async throws -> ExchangeRate {
        try await currenciesApi.getExchangeRateFor(
            currencyCode: currencyCode,
            date: Date()
        )
    }
}

private extension Collection where Element: Hashable {
    func uniqued() -> [Element] {
        Array(Set(self))
    }
}
