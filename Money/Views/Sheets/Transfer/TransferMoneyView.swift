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
    @State private var sourceAmount = "0"
    @State private var destinationAmount = "0"
    
    enum FocusField: Hashable {
      case field
    }
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 15) {
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
                            amount: sourceAmount,
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
                    
                    HStack {
                        EnterAmountView(
                                symbol: source.currencySymbol,
                                value: $sourceAmount)
                        .focused($focusedField, equals: .field)
                       
                        if destination.type.isAccount &&
                            source.currencyCode != destination.currencyCode {
                            Divider()
                            EnterAmountView(
                                symbol: destination.currencySymbol,
                                value: $destinationAmount)
                        }

                    }
                    .frame(maxHeight: 50)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    if let exchangeRate {
                        Text("Exchange rate: \(prettify(val: 1 / exchangeRate, fractionLength: 3))")
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                    }
                    
                }
                .padding()
                Spacer()
            }
            
            .navigationTitle(destination.type.isAccount ? "New transaction" : "New expense")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                self.focusedField = .field
            }
            .onChange(of: destinationAmount) {
                updateSourceAmount()
            }
            .onChange(of: sourceAmount) {
                updateDestinationAmount()
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
                    .disabled(sourceAmount == "0")
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
            sourceAmount = prettify(val: (amount / exchangeRate), fractionLength: 0)
        } else {
            sourceAmount = "0"
        }
    }
    
    private func updateDestinationAmount() {
//        if let exchangeRate = exchangeRate, exchangeRate > 0, let amount = Double(sourceAmount) {
//            destinationAmount = prettify(val: (amount / exchangeRate), fractionLength: 0)
//        } else {
//            destinationAmount = "0"
//        }
    }
    
    private func loadRates(sourceCode: String, destinationCode: String) async throws -> Double? {
        let rates = try await currenciesApi.getExchangeRateFor(currencyCode: sourceCode)
        return rates.currency[sourceCode]?[destinationCode]
    }
}
