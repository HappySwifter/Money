//
//  Preferences.swift
//  Money
//
//  Created by Artem on 07.03.2024.
//

import Foundation
import DataProvider

@MainActor
@Observable
class Preferences {
    private let userDefaults = UserDefaults.standard
    private let currenciesManager: CurrenciesManager
    
    init(currenciesManager: CurrenciesManager) {
        self.currenciesManager = currenciesManager
    }
            
    func getUserLocalCurrency() -> CurrencyStruct? {
        guard let currencyId = Locale.current.currency?.identifier else { return nil }
        return currenciesManager.getCurrencyWith(code: currencyId.lowercased())
    }
    
    func setRates(data: Data, date: String, currency: String) {
        userDefaults.setValue(data, forKey: "rate:\(date):\(currency)")
    }
    
    func getRates(date: String, currency: String) -> Data? {
        return userDefaults.data(forKey: "rate:\(date):\(currency)")
    }
}
