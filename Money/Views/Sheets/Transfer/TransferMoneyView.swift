//
//  EnterAmountView.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import SwiftUI
import SwiftData

struct TransferMoneyView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(CurrenciesApi.self) private var currenciesApi
    @Query(sort: \Account.orderIndex) private var accounts: [Account]
    @Query(sort: \SpendCategory.date) private var categories: [SpendCategory]
    
    @State var source: Transactionable
    @State var destination: Transactionable
    @Binding var isSheetPresented: Bool
    
    @State private var exchangeRate: Double?
    @State private var sourceAmount = 0.0
    @State private var destinationAmount = "0"
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    HStack {
                        Menu {
                            switch source.type {
                            case .account:
                                CurrencyMenuListView(
                                    selectedItem: $source,
                                    accounts: accounts,
                                    categories: nil) {
                                    updateRate()
                                }
                            case .category:
                                Color.clear
                            }
                        } label: {
                            TransactionAccountView(
                                viewType: .source,
                                amount: prettify(val: sourceAmount, fractionLength: 2),
                                item: source,
                                showAmount: destination.type.isAccount
                            )
                        }
                        .buttonStyle(.plain)
                        .environment(\.menuOrder, .fixed)
                        
                        Menu {
                            switch destination.type {
                            case .account:
                                CurrencyMenuListView(
                                    selectedItem: $destination,
                                    accounts: accounts,
                                    categories: nil)
                                {
                                    updateRate()
                                }
                                
                                Divider()
                                CurrencyMenuListView(
                                    selectedItem: $destination,
                                    accounts: nil,
                                    categories: categories)
                                {
                                    updateRate()
                                }
                            case .category:
                                CurrencyMenuListView(
                                    selectedItem: $destination,
                                    accounts: nil,
                                    categories: categories)
                                {
                                    updateRate()
                                }
                                Divider()
                                CurrencyMenuListView(
                                    selectedItem: $destination,
                                    accounts: accounts,
                                    categories: nil)
                                {
                                    updateRate()
                                }
                            }
                        } label: {
                            TransactionAccountView(
                                viewType: .destination,
                                amount: destinationAmount,
                                item: destination,
                                showAmount: true
                            )
                        }
                        .buttonStyle(.plain)
                        .environment(\.menuOrder, .fixed)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                       
                    
                    TextField("0", text: $destinationAmount)
        //            Text(amount)
                        .font(.title2)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)

                    
                    if let exchangeRate = exchangeRate {
                        HStack {
                            Text("Exchange rate: ")
                            Text(prettify(val: exchangeRate, fractionLength: 3))
                            Spacer()
                        }
                        .foregroundStyle(Color.gray)
                        .padding(.vertical)
                    }
                    
                }
                .padding()
                Spacer()

                CalculatorView(
                    viewModel: CalculatorViewModel(showCalculator: false),
                    resultString: $destinationAmount)
            }

            .navigationTitle(destination.type.isAccount ? "New transaction" : "New expense")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: destinationAmount) {
                updateSourceAmount()
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Group {
                        if destination.type.isCategory {
                            Button( " Done ") {
                                makeTransfer()
                            }
                        } else {
                            NavigationLink {
                                ExchangeRateView()
                            } label: {
                                Text(" Next ")
                            }
                        }
                    }
                    .disabled(destinationAmount == "0")
                    .buttonStyle(DoneButtonStyle())
                }
            }
        }
    }
    
    private func makeTransfer() {
        if destinationAmount.last == "," {
            destinationAmount = String(destinationAmount.dropLast())
        }
        guard let amount = Double(destinationAmount) else {
            assert(false)
            return
        }
        guard source.credit(amount: amount) else {
            return
        }
        if destination.type.isAccount {
            destination.deposit(amount: amount)
        }
        let transaction = Transaction(amount: amount,
                                      sourceId: source.id,
                                      destination: destination.type)
        modelContext.insert(transaction)
        isSheetPresented.toggle()
    }
    
    private func updateRate() {
        guard destination.type.isAccount else {
            exchangeRate = nil
            return
        }
        Task {
            exchangeRate = try await loadRates(
                sourceCode: source.currencyCode,
                destinationCode: destination.currencyCode) ??
            0
            updateSourceAmount()
        }
        
    }
    
    private func updateSourceAmount() {
        if let exchangeRate = exchangeRate, exchangeRate > 0, let amount = Double(destinationAmount) {
            sourceAmount = amount / exchangeRate
        } else {
            sourceAmount = 0.0
        }
    }
    
    private func loadRates(sourceCode: String, destinationCode: String) async throws -> Double? {
        let rates = try await currenciesApi.getExchangeRateFor(currencyCode: sourceCode)
        return rates.currency[sourceCode]?[destinationCode]
    }
}

//#Preview {
//    TransferMoneyView(source: nil,
//        destination: nil,
//                      isSheetPresented: .constant(true))
//}
