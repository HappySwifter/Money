//
//  AllAccountsView.swift
//  Money
//
//  Created by Artem on 09.03.2024.
//

import SwiftUI
import SwiftData

struct AllAccountsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Preferences.self) private var preferences
    @Environment(CurrenciesApi.self) private var currenciesApi
    
    @Query(sort: \Account.orderIndex) var accounts: [Account]

    
    @State var userCurrency: Currency
    
    var userCurrencies: [Currency] {
        var set = Set<Currency>()
        accounts.forEach { set.insert(Currency(code: $0.currencyCode,
                                               name: $0.currencyName,
                                               icon: $0.currencySymbol)) }
        set.insert(userCurrency)
        return Array(set)
    }

    var body: some View {
        VStack {
            List {
                ForEach(accounts) { acc in
                    HStack {
                        Text(acc.name)
                        Text(acc.currencySymbol)
                        Spacer()
                        Text(getAmountStringWith(code: acc.currencyCode, val: acc.amount))
                    }
                }
                .onMove(perform: updateOrder)
                .onDelete(perform: deleteAccount)
            }
            NavigationLink {
                CurrencyPicker(selectedCurrency: $userCurrency, currenciesToShow: userCurrencies)
            } label: {
                Text("Selected currency: \(userCurrency.name)")
            }
        }
        .onChange(of: userCurrency) {
            preferences.updateUser(currency: userCurrency)
        }
        .toolbar {
            EditButton()
        }
    }
    
    private func deleteAccount(at offsets: IndexSet) {
        for i in offsets {
            modelContext.delete(accounts[i])
        }
    }
    
    private func updateOrder(from: IndexSet, to: Int) {
        var updatedAccounts = accounts
        updatedAccounts.move(fromOffsets: from, toOffset: to)
        updatedAccounts.updateOrderIndices()
    }
}
