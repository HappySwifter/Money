//
//  CurrenciesManager.swift
//  Money
//
//  Created by Artem on 19.11.2024.
//

import Foundation
import OSLog
import DataProvider

@MainActor
@Observable final class CurrenciesManager {
    private let logger = Logger(subsystem: "Money", category: #file)
    private(set) var currencies: [AccountCurrency] = []
    
    init() {
        loadCurrencies()
    }
    
    private func loadCurrencies() {
        do {
            currencies = try AccountCurrency.loadFromJson()
            currencies.sort(by: { $0.name < $1.name })
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
    
    public func getCurrencyWith(code: String) -> AccountCurrency? {
        currencies.first(where: { $0.code == code })
    }
}
