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
    @State private var currencyCode: String?
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 30) {
                IconAndNameView(focusNameField: true, account: $account)
                HStack {
                    NavigationLink(destination: MyCurrenciesView(selectedCurrencyCode: $currencyCode)) {
                        Text(currencyCode ?? "")
                            .font(.title)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .cornerRadiusWithBorder(radius: Constants.fieldCornerRadius)
                    }
                    NewAccountAmountView(account: $account)
                }
                ChooseColorView(account: $account)
                Spacer()
            }
            .padding()
            .task {
                do {
                    if currencyCode == nil {
                        currencyCode = try await dataHandler?.getBaseCurrency().code
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
        guard let currencyCode else { return }
        Task { @MainActor in
            do {
                if let accountsCount = try await dataHandler?.getAccountsCount() {
                    account.updateOrder(index: accountsCount)
                    let selectedCurrency = await dataHandler?.getCurrencyBy(code: currencyCode)
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
