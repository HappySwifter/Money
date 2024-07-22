//
//  NewAccountView.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import SwiftUI
import DataProvider

@MainActor
struct NewAccountView: View {
    @Environment(\.dataHandlerWithMainContext) private var dataHandlerMainContext
    @Environment(Preferences.self) private var preferences
    
    @Binding var isSheetPresented: Bool
    var isClosable = true
    var completion: (() -> ())?
    
    @State private var currency: MyCurrency?
    @State private var account = SchemaV1.Account(orderIndex: 0,
                                                  name: "",
                                                  color: SwiftColor.green,
                                                  isAccount: true,
                                                  amount: 0)
    @State private var icon = Icon(name: "banknote.fill", color: SwiftColor.blue, isMulticolor: true)
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    AccountView(item: account,
                                currency: $currency,
                                selected: .constant(false),
                                longPressHandler: nil)
                    IconAndNameView(focusNameField: true, account: $account, icon: $icon)
                    HStack {
                        NewAccountChooseCurrencyView(currency: $currency)
                        NewAccountAmountView(account: $account)
                    }
                    NewAccountChooseColorView(account: $account, isCategory: false)
                }
                .padding()
            }
            .task {
                currency = try? await preferences.getUserCurrency()
                await MainActor.run {
                    account.icon = icon
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                if isClosable {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") {
                            isSheetPresented.toggle()
                        }
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
        Task { @MainActor in
            do {
                if let accountsCount = try await dataHandlerMainContext()?.getAccountsCount() {
                    account.updateOrder(index: accountsCount)
                }
                account.currency = currency
                completion?()
                isSheetPresented.toggle()
            } catch {
                print(error)
            }
        }
        
    }
    
    //    @MainActor
    //    private func addItem() {
    //      let createDataHandler = createDataHandler
    //      Task.detached {
    //        if let dataHandler = await createDataHandler() {
    //            try await dataHandler.new(account: account)
    //        }
    //      }
    //    }
}
