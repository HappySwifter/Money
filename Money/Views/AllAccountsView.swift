//
//  AllAccountsView.swift
//  Money
//
//  Created by Artem on 09.03.2024.
//

import SwiftUI
import SwiftData

struct AllAccountsView: View {
    @Environment(Preferences.self) private var preferences
    @Environment(CurrenciesApi.self) private var currenciesApi
    @Query(sort: \Account.date) private var accounts: [Account]
    
    @State var userCurrency: Currency
    
    var userCurrencyCodes: [Currency] {
        var set = Set<Currency>()
        accounts.forEach { set.insert(Currency(code: $0.currencyCode,
                                               name: $0.currencyName,
                                               icon: $0.currencySymbol)) }
        set.insert(userCurrency)
        return Array(set)
    }

    var body: some View {
        VStack {
            NavigationLink {
                CurrencyPicker(selectedCurrency: $userCurrency, showOnlyCurrencies: userCurrencyCodes)
            } label: {
                Text("Selected currency: \(userCurrency.name)")
            }
        }
    }
}
