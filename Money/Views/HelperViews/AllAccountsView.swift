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
//    @State var selectedCurrency = CurrencyStruct(code: "", name: "", symbol: nil)
    
    var body: some View {
        VStack {
            List {
                ForEach(accounts) { acc in
                    NavigationLink {
                        AccountDetailsView(account: acc, isPresentedModally: false)
                    } label: {
                        HStack {
                            Text(acc.name)
                            Text(acc.currencySymbol ?? "")
                            Spacer()
                            Text(getAmountStringWith(code: acc.currency?.code ?? "", val: acc.amount))
                        }
                        .padding(10)
                    }
                    .accessibilityIdentifier(AccountDetailsViewLink)
                }
                .onMove(perform: updateOrder)
                .onDelete(perform: deleteAccount)
            }
            Spacer()
//            NavigationLink {
//                MyCurrenciesView()
//            } label: {
//                Text("Selected currency: \(selectedCurrency.name)")
//            }
        }
        .task {
            self.accounts = await getAccounts()
//            self.selectedCurrency = preferences.getUserCurrency()
        }
//        .onChange(of: selectedCurrency) {
//            preferences.updateUser(currencyCode: selectedCurrency.code)
//            Task {
//                try? await expensesService.calculateSpentAndAccountsTotal()
//            }
//        }
        .toolbar {
            EditButton()
        }
        .navigationTitle("Accounts")
    }
    
    private func getAccounts() async -> [Account] {
        (try? await dataHandlerMainContext?.getAccounts()) ?? []

    }
    
    private func deleteAccount(at offsets: IndexSet) {
        let dataHandler = dataHandlerMainContext
        Task { @MainActor in
            if let dataHandler = dataHandler {
                for i in offsets {
                    await dataHandler.hide(account: accounts[i])
                }
                self.accounts = await getAccounts()
            }
        }
    }
    
    private func updateOrder(from: IndexSet, to: Int) {
//        var updatedAccounts = accounts
        accounts.move(fromOffsets: from, toOffset: to)
        for (index, item) in accounts.enumerated() {
            item.updateOrder(index: index)
        }
    }
}
