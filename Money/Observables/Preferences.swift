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

    func updateUser(currencyCode: String) {
        userDefaults.setValue(currencyCode, forKey: Keys.userCurrency.rawValue)
    }
    
    private func findUserCurrency() async -> MyCurrency? {
        if let code = userDefaults.string(forKey: Keys.userCurrency.rawValue) {
            return try? await handler.getCurrencyWith(code: code)
        } else {
            return nil
        }
    }
    
    func getUserCurrency() async throws -> MyCurrency {        
        if let userCurrency = await findUserCurrency() {
            return userCurrency
        } else if let currencyId = Locale.current.currency?.identifier,
                  let currency = try await handler.getCurrencyWith(code: currencyId)  {
            updateUser(currencyCode: currency.code)
            return currency
        } else if let usd = try await handler.getCurrencyWith(code: "usd") {
            updateUser(currencyCode: usd.code)
            return usd
        } else {
            let currency = await handler.newCurrency(name: "US Dollar", code: "usd", symbol: "$")
            updateUser(currencyCode: currency.code)
            return currency
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
