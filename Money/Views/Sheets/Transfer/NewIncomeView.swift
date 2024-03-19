//
//  NewIncomeView.swift
//  Money
//
//  Created by Artem on 18.03.2024.
//

import SwiftUI
import SwiftData

struct NewIncomeView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(filter: #Predicate<Account> { $0.isAccount },
           sort: \Account.orderIndex)
    private var accounts: [Account]
    
    @State var destination: Account
    @Binding var isSheetPresented: Bool
    @State private var destinationAmount = "0"
    
    
    var body: some View {
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
        
        Spacer()
        
        HStack {
            Spacer()
            Button(" Done ") {
                makeTransfer()
            }
            .disabled(destinationAmount.toDouble() == 0)
            .buttonStyle(DoneButtonStyle())
        }
        .padding(.horizontal)
        
        CalculatorView(viewModel: CalculatorViewModel(showCalculator: false),
                       resultString: $destinationAmount)
    }
    
    private func makeTransfer() {
        
        guard let amount = destinationAmount.toDouble(),
              amount > 0,
              destination.isAccount
        else {
            assert(false)
            return
        }
        destination.deposit(amount: amount)
        
        let transaction = Transaction(isIncome: true,
                                      sourceAmount: amount,
                                      source: destination,
                                      destinationAmount: amount,
                                      destination: destination)
        modelContext.insert(transaction)
        isSheetPresented.toggle()
    }
}
