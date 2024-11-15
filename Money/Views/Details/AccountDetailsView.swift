//
//  AccountDetailsView.swift
//  Money
//
//  Created by Artem on 03.03.2024.
//

import SwiftUI
import DataProvider
import OSLog

@MainActor
struct AccountDetailsView: View {
    private let logger = Logger(subsystem: "Money", category: #file)
    @Environment(ExpensesService.self) private var expensesService
    @Environment(\.dataHandlerWithMainContext) private var dataHandlerMainContext
    @Environment(\.dismiss) private var dismiss
    @State var account: Account
    var isPresentedModally = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                IconAndNameView(account: $account)
                ChooseColorView(account: $account)
                
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
        .dynamicTypeSize(.xLarge ... .xLarge)
        .navigationTitle(account.name)
        .navigationBarTitleDisplayMode(.inline)
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
                    logger.error("!!! error: \(error)")
                }
            }
        }
    }
}
