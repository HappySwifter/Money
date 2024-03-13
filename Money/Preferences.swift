//
//  Preferences.swift
//  Money
//
//  Created by Artem on 07.03.2024.
//

import Foundation

@Observable
class Preferences {
    @ObservationIgnored let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func updateUser(currency: MyCurrency) {
        let data = try! JSONEncoder().encode(currency)
        userDefaults.setValue(data, forKey: Keys.userCurrency.rawValue)
    }
    
    func getUserCurrency() -> MyCurrency {
        let locale = Locale.current
        if let userCurrency = decodeCurrencyData() {
            return userCurrency
        } else if let currencyId = locale.currency?.identifier {
            let currencyName = locale.localizedString(forCurrencyCode: currencyId)
            let localCurrency = MyCurrency(code: currencyId, name: currencyName ?? "", icon: "-")
            updateUser(currency: localCurrency)
            return localCurrency
        } else {
            let usd = MyCurrency(code: "usd", name: "US Dollar", icon: "")
            updateUser(currency: usd)
            return usd
        }
    }
    
    private func decodeCurrencyData() -> MyCurrency? {
        if let data = userDefaults.data(forKey: Keys.userCurrency.rawValue) {
            return try? JSONDecoder().decode(MyCurrency.self, from: data)
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
