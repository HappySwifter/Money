//
//  CalculateManager.swift
//  Money
//
//  Created by Artem on 20.07.2024.
//

import Foundation
import OSLog
import DataProvider

actor CalculateManager {
    private let dataHandler = DataHandler(modelContainer: DataProvider.shared.sharedModelContainer)
    private let logger = Logger(subsystem: "Money", category: "CurrenciesApi")
    private let preferences: Preferences
    private let currenciesApi: CurrenciesApi
    private let calendar = Calendar.current
        
    init(preferences: Preferences, currenciesApi: CurrenciesApi) {
        self.preferences = preferences
        self.currenciesApi = currenciesApi
    }

    struct Expenses {
        var accountsTotalAmount = ""
        var spentToday = ""
        var spentThisMonth = ""
        var availableMonths = [Date]()
        var availableYears = [Date]()
    }
    
    func calculateSpent() async throws -> Expenses {
        var expenses = Expenses()
        expenses.spentToday = ""
        let logDate = Date()
        let transactions = try await dataHandler.getTransaction()
        let userCurrency = try await preferences.getUserCurrency()
        let startOfMonth = TransactionPeriodType.month(value: Date()).startDate
        let groupedByDate = Dictionary(grouping: transactions, by: { $0.date.omittedTime })
        var spentThisMonth = 0.0
        var availableMonths = Set<Date>()
        
        for (date, trans) in groupedByDate {
            if date >= startOfMonth {
                let rates = try await currenciesApi.getExchangeRateFor(
                    currencyCode: userCurrency.code, date: date
                )
                
                let totalForDate = trans.reduce(0.0) { total, tran in
                    guard tran.isExpense else { return total }
                    return total + tran.convertAmount(to: userCurrency,
                                                      rates: rates)
                }
                if calendar.isDateInToday(date) {
                    expenses.spentToday = prettify(val: totalForDate,
                                                   fractionLength: 2,
                                                   currencySymbol: userCurrency.symbol)
                }
                spentThisMonth += totalForDate
            }
            let yearMonth = TransactionPeriodType.month(value: date).startDate
            availableMonths.insert(yearMonth)
            
        }
        if spentThisMonth > 0 {
            expenses.spentThisMonth = prettify(val: spentThisMonth, fractionLength: 2, currencySymbol: userCurrency.symbol)
        } else {
            expenses.spentThisMonth = ""
        }
        
        expenses.availableMonths = availableMonths
            .sorted(by: > )
        
        expenses.availableYears = Array(Set(expenses.availableMonths
            .map { TransactionPeriodType.year(value: $0).startDate }))
        expenses.accountsTotalAmount = try await calculateAccountsTotal()
        logger.warning("calculateSpent run time: \(Date().timeIntervalSince(logDate))")
        return expenses
    }
    
    private func calculateAccountsTotal() async throws -> String {
        let accounts = try await dataHandler.getAccounts()
        let userCur = try await preferences.getUserCurrency()
        let rates = try await currenciesApi.getExchangeRateFor(currencyCode: userCur.code, date: Date())
        
        var totalAmount = 0.0
        for account in accounts {
            if let changeRate = rates.value(for: account.currency!.code) {
                totalAmount += account.getAmountWith(changeRate: changeRate)
            } else {
                print("No conversation rate for \(account.currency!.code)")
            }
        }
        return prettify(val: totalAmount, fractionLength: 2, currencySymbol: userCur.symbol)
    }
}
