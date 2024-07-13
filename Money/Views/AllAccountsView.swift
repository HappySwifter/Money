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
//    @Environment(CurrenciesApi.self) private var currenciesApi
    @Environment(ExpensesService.self) private var expensesService

    
    @Query(filter: Account.accountPredicate(),
           sort: \Account.orderIndex)
    private var accounts: [Account]
    
    @State var userCurrency: MyCurrency
    @State var newAccountSheetPresend = false
    
    var userCurrencies: [MyCurrency] {
        var set = Set<MyCurrency>()
        accounts.forEach { set.insert($0.currency!) }
        set.insert(userCurrency)
        return Array(set)
    }
    
    var body: some View {
        VStack {
            if accounts.isEmpty {
                Button {
                    newAccountSheetPresend.toggle()
                } label: {
                    HStack {
                        Text("Create new account")
                    }
                }
                .padding(.vertical)
            } else {
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
            }
            Spacer()
            NavigationLink {
                CurrencyPicker(selectedCurrency: $userCurrency, currenciesToShow: userCurrencies)
            } label: {
                Text("Selected currency: \(userCurrency.name)")
            }
        }
        .onChange(of: userCurrency) {
            preferences.updateUser(currencyCode: userCurrency.code)
            try? expensesService.calculateSpent()
        }
        .sheet(isPresented: $newAccountSheetPresend, content: {
            NewAccountView(isSheetPresented: $newAccountSheetPresend)
        })
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
        for (index, item) in updatedAccounts.enumerated() {
            item.updateOrder(index: index)
        }
    }
}
