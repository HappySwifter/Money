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
                currency = try? await preferences.getUserCurrency()
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
                if let accountsCount = try await dataHandlerMainContext()?.getAccountsCount() {
                    account.updateOrder(index: accountsCount)
                }
                account.currency = currency
                completion?()
                isSheetPresented.toggle()
            } catch {
                logger.error("\(error.localizedDescription)")
            }
        }
    }
}
