//
//  SpendingsService.swift
//  Money
//
//  Created by Artem on 18.05.2024.
//

import Foundation
import SwiftUI
import SwiftData
import OSLog

@Observable
class ExpensesService {
    private let preferences: Preferences
    private let modelContext: ModelContext
    private let currenciesApi: CurrenciesApi
    private let calendar = Calendar.current
    private let logger = Logger(subsystem: "Money", category: "ExpensesService")
    
    var accountsTotalAmount = ""
    var spentToday = ""
    var spentThisMonth = ""
    var availableMonths = [Date]()
    var availableYears = [Date]()
    
    init(preferences: Preferences, modelContext: ModelContext, currenciesApi: CurrenciesApi) {
        self.preferences = preferences
        self.modelContext = modelContext
        self.currenciesApi = currenciesApi
        loadData()
    }
    
    private func loadData() {
        Task {
            do {
                try calculateSpent()
            } catch {
                print(error)
            }
        }
    }
    
    private func calculateAccountsTotal() {
        Task {
            do {
                let accounts = try fetchAccounts()
                let userCur = preferences.getUserCurrency()
                let rates = try await currenciesApi.getExchangeRateFor(currencyCode: userCur.code, date: Date())
                
                var totalAmount = 0.0
                for account in accounts {
                    if let changeRate = rates.value(for: account.currency!.code) {
                        totalAmount += account.getAmountWith(changeRate: changeRate)
                    } else {
                        print("No conversation rate for \(account.currency!.code)")
                    }
                }
                accountsTotalAmount = prettify(val: totalAmount, fractionLength: 2, currencySymbol: userCur.symbol)
            } catch {
                print(error)
            }
        }
    }
    
    func calculateSpent() throws {
        spentToday = ""
        Task {
            let logDate = Date()
            let transactions = try fetchTransaction()
            let userCurrency = preferences.getUserCurrency()
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
                        self.spentToday = prettify(val: totalForDate,
                                                   fractionLength: 2,
                                                   currencySymbol: userCurrency.symbol)
                    }
                    spentThisMonth += totalForDate
                }
                let yearMonth = TransactionPeriodType.month(value: date).startDate
                availableMonths.insert(yearMonth)
                
            }
            if spentThisMonth > 0 {
                self.spentThisMonth = prettify(val: spentThisMonth, fractionLength: 2, currencySymbol: userCurrency.symbol)
            } else {
                self.spentThisMonth = ""
            }

            
            self.availableMonths = availableMonths
                .sorted(by: > )
            
            self.availableYears = Array(Set(self.availableMonths
                .map { TransactionPeriodType.year(value: $0).startDate }))
            self.calculateAccountsTotal()
            logger.warning("calculateSpent run time: \(Date().timeIntervalSince(logDate))")
        }
    }
    
    func getExpensesFor(period: TransactionPeriodType) async throws -> [PieChartValue] {
        let logDate = Date()
        let transactions = try fetchTransaction(for: period)
        
        let userCur = preferences.getUserCurrency()
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
                                        color: trans.first?.destination?.color ?? "",
                                        data: trans))
        }
        let sorted = retVal.sorted(by: { $0.amount > $1.amount })
        logger.warning("getExpenses run time: \(Date().timeIntervalSince(logDate))")
        return sorted
    }
    
    private func fetchTransaction(for period: TransactionPeriodType? = nil) throws -> [Transaction] {
        var desc = FetchDescriptor<Money.Transaction>()
        if let period {
            desc.predicate = Transaction.predicateFor(period: period, calendar: calendar)
        }
        return try modelContext.fetch(desc)
    }
    
    private func fetchAccounts() throws -> [Account] {
        var desc = FetchDescriptor<Money.Account>()
        desc.predicate = Account.accountPredicate()
        return try modelContext.fetch(desc)
    }
}
