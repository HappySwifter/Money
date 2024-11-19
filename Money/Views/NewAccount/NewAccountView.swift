//
//  NewAccountView.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import SwiftUI
import DataProvider
import OSLog

@MainActor
struct NewAccountView: View {
    @Environment(\.dataHandlerWithMainContext) private var dataHandlerMainContext
    @Environment(Preferences.self) private var preferences
    @Environment(ExpensesService.self) private var expensesService
    private let logger = Logger(subsystem: "Money", category: "NewAccountView")
    @Binding var isSheetPresented: Bool
    var isClosable = true
    var completion: (() -> Void)?
    
    @State private var account = Account(orderIndex: 0,
                                         name: "",
                                         color: SwiftColor.lavender.rawValue,
                                         isAccount: true,
                                         amount: 0,
                                         iconName: "banknote.fill",
                                         iconColor: SwiftColor.accountColors.first!.rawValue)
    @State private var currency: MyCurrency?
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 30) {
                IconAndNameView(focusNameField: true, account: $account)
                HStack {
                    NewAccountChooseCurrencyView(currency: $currency)
                    NewAccountAmountView(account: $account)
                }
                ChooseColorView(account: $account)
                Spacer()
            }
            .padding()
            .task {
                currency = preferences.getUserCurrency()
            }
            .navigationBarTitleDisplayMode(.inline)
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
        .dynamicTypeSize(.xLarge ... .xLarge)
    }
    
    
    func saveAccountAndClose() {
        Task { @MainActor in
            do {
                if let dataHandler = dataHandlerMainContext {
                    let accountsCount = try await dataHandler.getAccountsCount()
                    account.updateOrder(index: accountsCount)
                    if let currency {
                        account.set(currency: currency)
                    }
                    await dataHandler.new(account: account)
                    try await expensesService.calculateAccountsTotal()
                    completion?()
                    isSheetPresented.toggle()
                }
            } catch {
                logger.error("\(error.localizedDescription)")
            }
        }
    }
}
