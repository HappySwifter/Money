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

@Observable final class ExpensesService {
    private let dataHandler = DataHandler(modelContainer: DataProvider.shared.sharedModelContainer)
    private let preferences: Preferences
    private let currenciesApi: CurrenciesApi
    private let calculateManager: CalculateManager
    private let calendar = Calendar.current
    private let logger = Logger(subsystem: "Money", category: "ExpensesService")
    
    private(set) var accountsTotalAmount = ""
    private(set) var spentToday = ""
    private(set) var spentThisMonth = ""
    private(set) var availableMonths = [Date]()
    private(set) var availableYears = [Date]()
    
    init(preferences: Preferences) {
        self.preferences = preferences
        let currenciesApi = CurrenciesApi(preferences: preferences)
        self.currenciesApi = currenciesApi
        self.calculateManager = CalculateManager(preferences: preferences,
                                                 currenciesApi: currenciesApi)
        loadData()
    }
    
    private func loadData() {
        Task {
            do {
                try await calculateSpent()
            } catch {
                print(error)
            }
        }
    }
    

    @MainActor
    func calculateSpent() async throws {
        let expenses = try await calculateManager.calculateSpent()
        accountsTotalAmount = expenses.accountsTotalAmount
        spentToday = expenses.spentToday
        spentThisMonth = expenses.spentThisMonth
        availableMonths = expenses.availableMonths
        availableYears = expenses.availableYears
        
    }
    
    func getExpensesFor(period: TransactionPeriodType) async throws -> [PieChartValue] {
        

        let logDate = Date()
        let transactions = try await dataHandler.getTransaction(for: period)
        
        let userCur = try await preferences.getUserCurrency()
        let groupedByName = Dictionary(grouping: transactions, by: { $0.destination?.name ?? "" })
        var retVal = [PieChartValue]()
        
        for (name, trans) in groupedByName {
            var totalForName = 0.0
            for tran in trans where tran.isExpense {
                let rates = try await currenciesApi.getExchangeRateFor(
                    currencyCode: userCur.code,
                    date: tran.date
                )
                totalForName += tran.convertAmount(to: userCur, rates: rates)
            }
            retVal.append(PieChartValue(amount: Int(round(totalForName)),
                                        title: name,
                                        color: trans.first?.destination?.icon?.color.rawValue ?? "",
                                        data: trans))
        }
        let sorted = retVal.sorted(by: { $0.amount > $1.amount })
        logger.warning("getExpenses run time: \(Date().timeIntervalSince(logDate))")
        return sorted
    }
}
