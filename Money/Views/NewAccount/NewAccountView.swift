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
    @Environment(\.dataHandlerWithMainContext) private var dataHandler
    @Environment(Preferences.self) private var preferences
    @Environment(ExpensesService.self) private var expensesService
    private let logger = Logger(subsystem: "Money", category: "NewAccountView")
    @Binding var isSheetPresented: Bool
    var isClosable = true
    var completion: (() -> Void)?
    
    @State private var account = Account(
        orderIndex: 0,
        name: "",
        color: "",
        isAccount: true,
        amount: 0,
        iconName: "banknote.fill",
        iconColor: SwiftColor.accountColors.first!.rawValue
    )
    @State private var currency: CurrencyStruct?
    @State private var initialAmount = "0"
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 30) {
                IconAndNameView(focusNameField: true, account: $account)
               
                EnterAmountView(
                    symbol: currency?.symbol ?? "",
                    isFocused: false,
                    value: $initialAmount
                )
                
                NavigationLink(destination: MyCurrenciesView(selectedCurrency: $currency)) {
                    CurrencyNameView(currency: currency)
                }
                .buttonStyle(.plain)
                
                ChooseColorView(account: $account)
                Spacer()
            }
            .padding()
            .task {
                do {
                    if currency == nil, let currencyModel = try await dataHandler?.getBaseCurrency() {
                        currency = CurrencyStruct(from: currencyModel)
                    }
                } catch {
                    print(error.localizedDescription)
                }
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
        guard let currency else { return }
        Task { @MainActor in
            do {
                if let accountsCount = try await dataHandler?.getAccountsCount() {
                    account.updateOrder(index: accountsCount)
                    account.setInitial(amount: initialAmount)
                    let selectedCurrency = await dataHandler?.getCurrencyBy(code: currency.code)
                    account.currency = selectedCurrency
                    await dataHandler?.save()
                    
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
