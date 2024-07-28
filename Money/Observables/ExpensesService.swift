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
    private let dataHandler = DataHandler(modelContainer: DataProvider.shared.sharedModelContainer)
    private let preferences: Preferences
    private let currenciesApi: CurrenciesApi
    private let calculateManager: CalculateManager
    private let calendar = Calendar.current
    
    private(set) var accountsTotalAmount = ""
    private(set) var spentToday = ""
    private(set) var spentThisMonth = ""
    
    init(preferences: Preferences) {
        self.preferences = preferences
        currenciesApi = CurrenciesApi(preferences: preferences)
        calculateManager = CalculateManager(preferences: preferences, currenciesApi: currenciesApi)
    }
    
    func calculateSpent() async throws {
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
        
        let userCur = try await preferences.getUserCurrency()
        let groupedByName = Dictionary(grouping: transactions, by: { $0.destination?.name ?? "" })
        var retVal = [PieChartValue]()
        
        for (name, trans) in groupedByName {
            var totalForName = 0.0
            for tran in trans where tran.type == .spending {
                let rates = try await currenciesApi.getExchangeRateFor(
                    currencyCode: userCur.code,
                    date: tran.date
                )
                totalForName += tran.convertAmount(to: userCur, rates: rates)
            }
            if totalForName > 0 {
                retVal.append(PieChartValue(amount: Int(round(totalForName)),
                                            title: name,
                                            color: trans.first?.destination?.icon?.color.rawValue ?? "",
                                            data: trans))
            }
        }
        let sorted = retVal.sorted(by: { $0.amount > $1.amount })
        print("getExpenses run time: \(Date().timeIntervalSince(logDate))")
        return sorted
    }
}

private extension Collection where Element: Hashable {
    func uniqued() -> [Element] {
        Array(Set(self))
    }
}
