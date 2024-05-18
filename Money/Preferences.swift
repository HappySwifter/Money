//
//  Preferences.swift
//  Money
//
//  Created by Artem on 07.03.2024.
//

import Foundation
import SwiftData

@Observable
class Preferences {
    @ObservationIgnored private let userDefaults: UserDefaults
    @ObservationIgnored private let modelContext: ModelContext
    
    init(userDefaults: UserDefaults, modelContext: ModelContext) {
        self.userDefaults = userDefaults
        self.modelContext = modelContext
    }
    
    func updateUser(currencyCode: String) {
        userDefaults.setValue(currencyCode, forKey: Keys.userCurrency.rawValue)
    }
    
    private func getUserCurrency() -> MyCurrency? {
        if let code = userDefaults.string(forKey: Keys.userCurrency.rawValue) {
            return fetchCurrencyBy(code: code)
        } else {
            return nil
        }
    }
    
    func getUserCurrency() -> MyCurrency {
        let locale = Locale.current
        if let userCurrency = getUserCurrency() {
            return userCurrency
        } else if let currencyId = locale.currency?.identifier,
                  let currency = fetchCurrencyBy(code: currencyId)  {
//            let currencyName = locale.localizedString(forCurrencyCode: currencyId)
            updateUser(currencyCode: currency.code)
            return currency
        } else if let usd = fetchCurrencyBy(code: "usd") {
            updateUser(currencyCode: usd.code)
            return usd
        } else {
            let usd = MyCurrency(code: "usd", name: "US Dollar", symbol: "$")
            updateUser(currencyCode: usd.code)
            modelContext.insert(usd)
            return usd
        }
    }
        
    private func fetchCurrencyBy(code: String) -> MyCurrency? {
        var desc = FetchDescriptor<MyCurrency>()
        let pred = #Predicate<MyCurrency> { val in
            val.code == code
        }
        desc.fetchLimit = 1
        desc.predicate = pred
        do {
            return try modelContext.fetch(desc).first
        } catch {
            print("Error fetchCurrencyBy: ", error)
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
