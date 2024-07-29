//
//  AccountDetailsView.swift
//  Money
//
//  Created by Artem on 03.03.2024.
//

import SwiftUI
import DataProvider

@MainActor
struct AccountDetailsView: View {
    @Environment(ExpensesService.self) private var expensesService
    @Environment(\.dataHandlerWithMainContext) private var dataHandlerMainContext
    @Environment(\.dismiss) private var dismiss
    @State var account: Account
    var isPresentedModally = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                AccountView(item: account,
                            currency: .constant(account.currency),
                            selected: .constant(false),
                            longPressHandler: nil)
                IconAndNameView(account: $account, icon: Binding(get: {
                    account.icon!
                }, set: {
                    account.icon = $0
                }))
                NewAccountChooseColorView(account: $account,
                                          isCategory: false)
                
                Spacer()
                Button("Hide account") {
                    withAnimation {
                        deleteAccountAndUpdateTotalAmount()
                        dismiss()
                    }
                }
                .buttonStyle(DeleteButton())
            }
            .padding()
        }
        .toolbar {
            if isPresentedModally {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func deleteAccountAndUpdateTotalAmount() {
        let dataHandler = dataHandlerMainContext
        Task { @MainActor in
            if let dataHandler = await dataHandler() {
                await dataHandler.hide(account: account)
                do {
                    try await expensesService.calculateAccountsTotal()
                } catch {
                    print("!!! error: ", error)
                }
            }
        }
    }
}
