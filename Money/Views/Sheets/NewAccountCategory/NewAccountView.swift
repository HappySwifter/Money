//
//  NewAccountView.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import SwiftUI
import SwiftData

struct NewAccountView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Preferences.self) private var preferences
    
    @Binding var isSheetPresented: Bool
    @State var currency: MyCurrency?
    @State var account = Account(orderIndex: 0,
                                 name: "",
                                 color: SwiftColor.allCases.randomElement()!,
                                 isAccount: true,
                                 amount: 0)
    @State var icon = Icon(name: "banknote.fill", color: .blue, isMulticolor: true)
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    AccountView(item: account,
                                currency: $currency,
                                selected: .constant(false),
                                longPressHandler: nil)
                    NewAccountEmojiAndNameView(focusNameField: true, account: $account, icon: $icon)
                    HStack {
                        NewAccountChooseCurrencyView(currency: $currency)
                        NewAccountAmountView(account: $account)
                    }
                    NewAccountChooseColorView(account: $account)
                }
                .padding()
            }
            .onAppear {
                currency = preferences.getUserCurrency()
                account.icon = icon
            }
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        isSheetPresented.toggle()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveAccountAndClose()
                    }
                    .disabled(account.name.isEmpty)
                }
            }
            .navigationTitle("New account")
        }
    }
    
    func saveAccountAndClose() {
        do {
            let accDesc = FetchDescriptor<Account>()
            let accountsCount = try modelContext.fetchCount(accDesc)
            account.updateOrder(index: accountsCount)
            account.currency = currency
            isSheetPresented.toggle()
        } catch {
            print(error)
        }
    }
}
