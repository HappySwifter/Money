//
//  Preferences.swift
//  Money
//
//  Created by Artem on 07.03.2024.
//

import Foundation

@Observable
class Preferences {
    let userDefaults: UserDefaults
    let currenciesApi: CurrenciesApi
    
    init(userDefaults: UserDefaults, currenciesApi: CurrenciesApi) {
        self.userDefaults = userDefaults
        self.currenciesApi = currenciesApi
    }
    
    func updateUser(currency: Currency) {
        let data = try! JSONEncoder().encode(currency)
        userDefaults.setValue(data, forKey: Keys.userCurrency.rawValue)
    }
    
    func getUserCurrency() -> Currency {
        if let userCurrency = decodeCurrencyData() {
            return userCurrency
        } else if let currencySymbol = Locale.current.currencySymbol,
                  let currencies = try? currenciesApi.getCurrencies(),
                  let localCurrency = currencies
            .filter({ $0.code.lowercased() == currencySymbol.lowercased() })
            .first
        {
            updateUser(currency: localCurrency)
            return localCurrency
        } else {
            let usd = Currency(code: "usd", name: "US Dollar", icon: "")
            updateUser(currency: usd)
            return usd
        }
    }
    
    private func decodeCurrencyData() -> Currency? {
        if let data = userDefaults.data(forKey: Keys.userCurrency.rawValue) {
            return try? JSONDecoder().decode(Currency.self, from: data)
        } else {
            return nil
        }
    }
    
    private enum Keys: String {
        case userCurrency
    }
}