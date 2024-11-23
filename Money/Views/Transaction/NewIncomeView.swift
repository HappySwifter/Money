//
//  NewIncomeView.swift
//  Money
//
//  Created by Artem on 18.03.2024.
//

import SwiftUI
import SwiftData
import DataProvider
import OSLog

@MainActor
struct NewIncomeView: View {
    private let logger = Logger(subsystem: "Money", category: "NewIncomeView")
    @Environment(\.dataHandlerWithMainContext) private var dataHandler
    @Environment(ExpensesService.self) private var expensesService
    
    @Query(filter: Account.accountPredicate(),
           sort: \Account.orderIndex)
    private var accounts: [Account]
    
    @State var destination: Account
    @Binding var isSheetPresented: Bool
    @State private var targetDate = Date()
    @State private var destinationAmount = ""
    @State private var comment = ""

    private var isDoneButtonDisabled: Bool {
        destinationAmount.toDouble() == 0 ||
        destinationAmount.toDouble() == nil ||
        !destination.isAccount
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    Menu {
                        Text("Accounts")
                        CurrencyMenuListView(selectedItem: $destination, data: accounts)
                    } label: {
                        HStack {
                            AccountView(item: $destination,
                                        selected: .constant(true),
                                        presentingType: .constant(.none))
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                    .environment(\.menuOrder, .fixed)
                    
                    EnterAmountView(
                        symbol: destination.currencySymbol ?? "",
                        isFocused: true,
                        value: $destinationAmount)
                    
                    TextField("", text: $comment, prompt: Text("Comment"), axis: .vertical)
                    
                    Spacer()
                    
                    HStack(alignment: .bottom) {
                        DatePicker("", selection: $targetDate, displayedComponents: .date)
                            .labelsHidden()
                        Spacer()
                        Button(" Done ") {
                            makeTransfer()
                        }
                        .disabled(isDoneButtonDisabled)
                        .buttonStyle(DoneButtonStyle())
                        .dynamicTypeSize(.xLarge ... .xLarge)
                    }
                    .padding(.bottom)
                }
                .padding(.horizontal)                
            }
            .navigationTitle("New income")
            .navigationBarTitleDisplayMode(.inline)
            .dynamicTypeSize(.xLarge ... .xLarge)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        isSheetPresented.toggle()
                    }
                }
            }
        }
    }
    
    private func makeTransfer() {
        Task { @MainActor in
            let amount = destinationAmount.toDouble()!
            destination.deposit(amount: amount)
            let comment = comment.isEmpty ? nil : comment
            let transaction = MyTransaction(date: targetDate,
                                            isIncome: true,
                                            sourceAmount: amount,
                                            source: nil,
                                            destinationAmount: amount,
                                            destination: destination,
                                            comment: comment)
            await dataHandler?.new(transaction: transaction)
            isSheetPresented.toggle()
            await calculateTotal()
        }
    }
    
    private func calculateTotal() async {
        do {
            try await expensesService.calculateAccountsTotal()
        } catch let error as NetworkError {
            logger.error("\(error.description)")
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
}
