//
//  SpendingsService.swift
//  Money
//
//  Created by Artem on 18.05.2024.
//

import Foundation
import SwiftUI
import SwiftData

struct SpentAmountByDate {
    let date: Date
    let amount: Double
}

@Observable
class ExpensesService {
    private let preferences: Preferences
    private let modelContext: ModelContext
    private let currenciesApi: CurrenciesApi
    private let calendar = Calendar.current
    
    var spendings = [SpentAmountByDate]()
    var spentToday = ""
    var spentThisMonth = ""
    var availableMonths = [String]()
    var availableYears = [String]()
    
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
    
    func calculateSpent() throws {
        Task {
            let transactions = try fetchTransaction()
            let userCurrency = preferences.getUserCurrency()
            let groupedByDate = Dictionary(grouping: transactions, by: { $0.date.omittedTime })
            let comp = calendar.dateComponents([.year, .month], from: Date())
            let startOfMonth = calendar.date(from: comp)!
            
            var allData = [SpentAmountByDate]()
            var spentThisMonth = 0.0
            var availableMonths = Set<Date>()
            
            for (date, trans) in groupedByDate {
                let rates = try await currenciesApi.getExchangeRateFor(currencyCode: userCurrency.code, date: date)
                
                let totalForDate = trans.reduce(0.0) { total, tran in
                    guard tran.isExpense else { return total }
                    return total + tran.convertAmount(to: userCurrency,
                                                      rates: rates)
 
                }
                allData.append(SpentAmountByDate(date: date, amount: totalForDate))
                if calendar.isDateInToday(date) {
                    spentToday = prettify(val: totalForDate, fractionLength: 2, currencyCode: userCurrency.symbol)
                }
                if date >= startOfMonth {
                    print(date, totalForDate)
                    spentThisMonth += totalForDate
                }
                let comp = calendar.dateComponents([.year, .month], from: date)
                let yearMonth = calendar.date(from: comp)!
                availableMonths.insert(yearMonth)
                
            }
            self.spendings = allData
            
            self.spentThisMonth = prettify(val: spentThisMonth, fractionLength: 2, currencyCode: userCurrency.symbol)
           
            self.availableMonths = availableMonths
                .sorted(by: > )
                .map { $0.monthYearString }
            
            self.availableYears = self.availableMonths
                .map { String($0.split(separator: " ").last ?? "") }
        }
    }
    
    func getExpensesFor(timePeriod: PeriodType, value: Date) async throws -> [PieChartValue] {
        let transactions = try fetchTransactionFor(date: value)
        let userCur = preferences.getUserCurrency()
        let groupedByName = Dictionary(grouping: transactions, by: { $0.destination.name })
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
            retVal.append(PieChartValue(amount: Int(round(totalForName)), title: name, data: trans))
        }
        return retVal.sorted(by: { $0.amount > $1.amount })
    }

    private func fetchTransaction() throws -> [Transaction] {
        let desc = FetchDescriptor<Transaction>()
        return try modelContext.fetch(desc)
    }
    
    private func fetchTransactionFor(date: Date) throws -> [Transaction] {
        var desc = FetchDescriptor<Money.Transaction>()
        desc.predicate = Transaction.predicateFor(date: date)
        return try modelContext.fetch(desc)
    }
}


extension Transaction {

    static func predicateFor(date: Date) -> Predicate<Transaction> {
        let targetDate = Calendar.current.startOfDay(for: date)

        return #Predicate<Transaction> { tran in
            return tran.date >= targetDate && !tran.isIncome && !tran.destination.isAccount
        }
    }

    static func thisMonthPredicate() -> Predicate<Transaction> {
        let comp = Calendar.current
            .dateComponents([.year, .month], from: Date())
        let startOfMonth = Calendar.current.date(from: comp)!

        return #Predicate<Transaction> { tran in
            return tran.date >= startOfMonth && !tran.isIncome
        }
    }
}
