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
    @Environment(ExpensesService.self) private var expensesService
    
//    @Query(
//        filter: Account.accountPredicate(),
//        sort: \Account.orderIndex)
    @State private var accounts = [Account]()
    @State private var userCurrencies = [MyCurrency]()
    @State var selectedCurrency: MyCurrency
    
    
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
        .onAppear {
            fetchAccounts()
            userCurrencies = getUserCurrencies()
        }
        .onChange(of: selectedCurrency) {
            preferences.updateUser(currencyCode: selectedCurrency.code)
            try? expensesService.calculateSpent()
        }
        .toolbar {
            EditButton()
        }
    }
    
    private func fetchAccounts() {
        var desc = FetchDescriptor<Account>()
        desc.predicate = Account.accountPredicate()
        desc.sortBy = [SortDescriptor(\.orderIndex)]
        self.accounts = (try? modelContext.fetch(desc)) ?? []
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
        for i in offsets {
            modelContext.delete(accounts[i])
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
