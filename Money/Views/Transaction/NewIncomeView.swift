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

    private let useSystemKeyboard = true
    private var isDoneButtonDisabled: Bool {
        destinationAmount.toDouble() == 0 ||
        destinationAmount.toDouble() == nil ||
        !destination.isAccount
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 10) {
                    Menu {
                        Text("Accounts")
                        CurrencyMenuListView(selectedItem: $destination, data: accounts)
                    } label: {
                        TransactionAccountView(
                            viewType: TransferMoneyView.FieldFocusType.destination,
                            item: destination
                        )
                    }
                    .buttonStyle(.plain)
                    .environment(\.menuOrder, .fixed)
                    
                    EnterAmountView(
                        symbol: destination.currency?.symbol ?? "",
                        isFocused: true,
                        value: $destinationAmount,
                        useTextField: useSystemKeyboard)
                    
//                    HStack {
                        TextField("", text: $comment, prompt: Text("Comment"), axis: .vertical)
//                        Spacer()
//                    }
                    
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
                        .dynamicTypeSize(.xSmall ... .accessibility2)
                    }
                    .padding(.bottom)
                }
                .padding(.horizontal)
                
                if !useSystemKeyboard {
                    CalculatorView(viewModel: CalculatorViewModel(showCalculator: false),
                                   resultString: $destinationAmount)
                }
            }
            .navigationTitle("New income")
            .navigationBarTitleDisplayMode(.inline)
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
            await dataHandler()?.new(transaction: transaction)
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
