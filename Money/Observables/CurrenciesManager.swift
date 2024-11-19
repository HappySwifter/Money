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
    private(set) var currencies: [MyCurrency] = []
    
    init() {
        loadCurrencies()
    }
    
    private func loadCurrencies() {
        Task { [logger] in
            do {
                let d = Date()
                currencies.removeAll()
                
                let currenciesFromJson = try MyCurrency.loadFromJson()
                let symbols = try CurrencySymbol.loadFromJson()
                
                for (code, name) in currenciesFromJson where !code.isEmpty && !name.isEmpty {
                    let symbol = symbols.findWith(code: code)?.symbol
                    let currency = MyCurrency(code: code, name: name, symbol: symbol)
                    currencies.append(currency)
                }
                logger.info("Finish loading currencies in \(Date().timeIntervalSince(d)) seconds")
            } catch {
                logger.error("\(error.localizedDescription)")
            }
        }
    }
        
    public func getCurrencyWith(code: String) -> MyCurrency? {
        currencies.first(where: { $0.code == code })
    }
}
