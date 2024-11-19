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
    private let handler = DataHandler(modelContainer: DataProvider.shared.sharedModelContainer, mainActor: true)
    private let currenciesManager: CurrenciesManager
    
    init(currenciesManager: CurrenciesManager) {
        self.currenciesManager = currenciesManager
    }
    
    func updateUser(currencyCode: String) {
        userDefaults.setValue(currencyCode, forKey: Keys.userCurrency.rawValue)
    }
        
    func getUserCurrency() -> MyCurrency {
        if let userCurrency = findUserCurrency() {
            return userCurrency
        } else if let currencyId = Locale.current.currency?.identifier, let currency = currenciesManager.getCurrencyWith(code: currencyId) {
            updateUser(currencyCode: currency.code)
            return currency
        } else {
            let usd = currenciesManager.getCurrencyWith(code: "usd")!
            updateUser(currencyCode: usd.code)
            return usd
        }
    }
    
    private func findUserCurrency() -> MyCurrency? {
        if let code = userDefaults.string(forKey: Keys.userCurrency.rawValue) {
            return currenciesManager.getCurrencyWith(code: code)
        } else {
            return nil
        }
    }
    
    func setRates(data: Data, date: String, currency: String) {
        userDefaults.setValue(data, forKey: "rate:\(date):\(currency)")
    }
    
    func getRates(date: String, currency: String) -> Data? {
        return userDefaults.data(forKey: "rate:\(date):\(currency)")
    }
    
    private enum Keys: String {
        case userCurrency
    }
}
