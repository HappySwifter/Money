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
class SpendingsService {
    private let preferences: Preferences
    private let modelContext: ModelContext
    private let currenciesApi: CurrenciesApi
    private let calendar = Calendar.current
    
    var spendings = [SpentAmountByDate]()
    var spentToday = ""
    var spentThisMonth = ""
    
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
            
            for (date, trans) in groupedByDate {
                let rates = try await currenciesApi.getExchangeRateFor(currencyCode: userCurrency.code, date: date)
                
                let totalForDate = trans.reduce(0.0) { total, tran in
                    
                    if tran.isIncome || tran.destination.isAccount {
                        return total
                    } else {
                        guard let sourceCurrency = tran.source.currency else { assert(false) }
                       
                        if userCurrency.code == sourceCurrency.code {
                            return total + tran.sourceAmount
                        } else {
                            if let exchRate = rates.value(for: sourceCurrency.code) {
                                return total + tran.sourceAmount / exchRate
                            } else {
                                assert(false, "ERROR no rate for code \(sourceCurrency.code)")
                                return total
                            }
                        }
                    }
                }
                allData.append(SpentAmountByDate(date: date, amount: totalForDate))
                if calendar.isDateInToday(date) {
                    spentToday = prettify(val: totalForDate, fractionLength: 2, currencyCode: userCurrency.symbol)
                }
                if date >= startOfMonth {
                    print(date, totalForDate)
                    spentThisMonth += totalForDate
                }
            }
            self.spendings = allData
            self.spentThisMonth = prettify(val: spentThisMonth, fractionLength: 2, currencyCode: userCurrency.symbol)
        }
    }

    private func fetchTransaction() throws -> [Transaction] {
        let desc = FetchDescriptor<Transaction>()
        return try modelContext.fetch(desc)
    }
}
//
//struct SpendingsServiceKey: EnvironmentKey {
//    static var defaultValue = SpendingsService()
//}
