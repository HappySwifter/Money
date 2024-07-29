//
//  NewIncomeView.swift
//  Money
//
//  Created by Artem on 18.03.2024.
//

import SwiftUI
import SwiftData
import DataProvider

@MainActor
struct NewIncomeView: View {
    @Environment(\.dataHandlerWithMainContext) private var dataHandler
    
    @Query(filter: Account.accountPredicate(),
           sort: \Account.orderIndex)
    private var accounts: [Account]
    
    @State var destination: Account
    @Binding var isSheetPresented: Bool
    @State private var destinationAmount = "0"
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Menu {
                        Text("Accounts")
                        CurrencyMenuListView(selectedItem: $destination, data: accounts)
                    } label: {
                        TransactionAccountView(
                            viewType: TransferMoneyView.ItemType.destination,
                            item: destination
                        )
                    }
                    .buttonStyle(.plain)
                    .environment(\.menuOrder, .fixed)
                    
                    EnterAmountView(
                        symbol: destination.currency?.symbol ?? "",
                        isFocused: true,
                        value: $destinationAmount)
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Button(" Done ") {
                            makeTransfer()
                        }
                        .disabled(destinationAmount.toDouble() == 0)
                        .buttonStyle(DoneButtonStyle())
                        .dynamicTypeSize(.xSmall ... .accessibility2)
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal)
                
                CalculatorView(viewModel: CalculatorViewModel(showCalculator: false),
                               resultString: $destinationAmount)
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
        
        guard let amount = destinationAmount.toDouble(),
              amount > 0,
              destination.isAccount
        else {
            assert(false)
            return
        }
        Task { @MainActor in
            destination.deposit(amount: amount)
        
            let transaction = MyTransaction(isIncome: true,
                                            sourceAmount: amount,
                                            source: nil,
                                            destinationAmount: amount,
                                            destination: destination)
            await dataHandler()?.new(transaction: transaction)
            isSheetPresented.toggle()
        }
    }
}

//#Preview {
//    var desc = FetchDescriptor<Account>()
//    desc.predicate = Account.accountPredicate()
//    let accounts = try? previewContainer.mainContext.fetch(desc)
//    
//    return NewIncomeView(destination: accounts!.first!, isSheetPresented: .constant(true))
//        .modelContainer(previewContainer)
//}

//@MainActor
//let previewContainer: ModelContainer = {
//    do {
//        let container = try ModelContainer(for: Account.self,
//                                           configurations: .init(isStoredInMemoryOnly: true))
//        for name in ["Bank", "Cash", "X", "Loooooooooooon account"] {
//            let acc = Account(orderIndex: 0, name: name, color: SwiftColor.allCases.randomElement()!, isAccount: true, amount: 1000)
//            acc.currency = MyCurrency(code: "RUB", name: "Ruble", symbol: "R")
//            acc.icon = Icon(name: "banknote", color: SwiftColor.allCases.randomElement()!, isMulticolor: false)
//            container.mainContext.insert(acc)
//        }
//        
//        for name in ["Food", "Clothes", "X", "Looooooooooooong cat"] {
//            let acc = Account(orderIndex: 0, name: name, color: .clear, isAccount: false, amount: 0)
//            acc.icon = Icon(name: "basket", color: SwiftColor.allCases.randomElement()!, isMulticolor: false)
//            container.mainContext.insert(acc)
//        }
//
//        return container
//    } catch {
//        fatalError("Failed to create container")
//    }
//}()

