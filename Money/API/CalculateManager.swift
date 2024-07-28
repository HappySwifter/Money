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
    }
    
    func calculateSpent() async throws -> Expenses {
        let logDate = Date()
        
        // fetching only this month transactions that is isExpenses
        let thisMonthPeriod = TransactionPeriodType.month(value: Date())
        let transactions = try await dataHandler.getTransaction(for: thisMonthPeriod)
        let userCurrency = try await preferences.getUserCurrency()
        var thisMonthTotal = 0.0
        var todayTotal = 0.0
        
        for tran in transactions where tran.isExpense {
            let rates = try await currenciesApi.getExchangeRateFor(
                currencyCode: userCurrency.code,
                date: tran.date
            )
            let amount = tran.convertAmount(to: userCurrency, rates: rates)
            thisMonthTotal += amount
            if calendar.isDateInToday(tran.date) { todayTotal += amount }
        }
        let thisMonthString = prettify(val: thisMonthTotal,
                                       fractionLength: 2,
                                       currencySymbol: userCurrency.symbol)
        let todayString = prettify(val: todayTotal,
                                   fractionLength: 2,
                                   currencySymbol: userCurrency.symbol)
        
        let accountsTotalAmount = try await calculateAccountsTotal()
        
        logger.warning("calculateSpent run time: \(Date().timeIntervalSince(logDate))")
        
        return Expenses(accountsTotalAmount: accountsTotalAmount,
                        spentToday: todayString,
                        spentThisMonth: thisMonthString)
    }
    
    func calculateAccountsTotal() async throws -> String {
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
