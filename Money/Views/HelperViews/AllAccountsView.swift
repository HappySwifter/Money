//
//  AllAccountsView.swift
//  Money
//
//  Created by Artem on 09.03.2024.
//

import SwiftUI
import DataProvider

@MainActor
struct AllAccountsView: View {
    @Environment(\.dataHandlerWithMainContext) private var dataHandlerMainContext
    @Environment(Preferences.self) private var preferences
    @Environment(ExpensesService.self) private var expensesService
    

    @State private var accounts = [Account]()
    @State private var userCurrencies = [MyCurrency]()
    @State var selectedCurrency = MyCurrency(code: "", name: "", symbol: nil)
    
    
    var body: some View {
        VStack {
            List {
                ForEach(accounts) { acc in
                    NavigationLink {
                        AccountDetailsView(account: acc)
                    } label: {
                        HStack {
                            Text(acc.name)
                            Text(acc.currency?.symbol ?? "")
                            Spacer()
                            Text(getAmountStringWith(code: acc.currency?.code ?? "", val: acc.amount))
                        }
                    }
                    .accessibilityIdentifier(AccountDetailsViewLink)
                }
                .onMove(perform: updateOrder)
                .onDelete(perform: deleteAccount)
            }
            Spacer()
            NavigationLink {
                CurrencyPicker(selectedCurrency: $selectedCurrency, currenciesToShow: userCurrencies)
            } label: {
                Text("Selected currency: \(selectedCurrency.name)")
            }
        }
        .task {
            self.accounts = (try? await dataHandlerMainContext()?.getAccounts()) ?? []
            self.userCurrencies = getUserCurrencies()
            if let cur = try? await preferences.getUserCurrency() {
                selectedCurrency = cur
            }
        }
        .onChange(of: selectedCurrency) {
            preferences.updateUser(currencyCode: selectedCurrency.code)
            Task {
                try? await expensesService.calculateSpent()
            }
        }
        .toolbar {
            EditButton()
        }
    }

    private func getUserCurrencies() -> [MyCurrency] {
        var set = Set<MyCurrency>()
        accounts.forEach {
            if let cur = $0.currency {
                set.insert(cur)
            }
        }
        set.insert(selectedCurrency)
        return Array(set)
    }
    
    private func deleteAccount(at offsets: IndexSet) {
        let dataHandler = dataHandlerMainContext
        Task { @MainActor in
            if let dataHandler = await dataHandler() {
                for i in offsets {
                    try? await dataHandler.deleteAccount(accounts[i])
                }
            }
        }
    }
    
    private func updateOrder(from: IndexSet, to: Int) {
        var updatedAccounts = accounts
        updatedAccounts.move(fromOffsets: from, toOffset: to)
        for (index, item) in updatedAccounts.enumerated() {
            item.updateOrder(index: index)
        }
    }
}
