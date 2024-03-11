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
    
    enum ItemType: Hashable {
        case source
        case destination
    }
    @State private var focusedField = ItemType.source
    
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
                                    updateRate(itemType: .source)
                                }
                        case .category:
                            Color.clear
                        }
                    } label: {
                        TransactionAccountView(
                            viewType: .source,
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
                                updateRate(itemType: .destination)
                            }
                            
                            Divider()
                            CurrencyMenuListView(
                                selectedItem: $destination,
                                accounts: nil,
                                categories: categories)
                            {
                                updateRate(itemType: .destination)
                            }
                        case .category:
                            CurrencyMenuListView(
                                selectedItem: $destination,
                                accounts: nil,
                                categories: categories)
                            {
                                updateRate(itemType: .destination)
                            }
                            Divider()
                            CurrencyMenuListView(
                                selectedItem: $destination,
                                accounts: accounts,
                                categories: nil)
                            {
                                updateRate(itemType: .destination)
                                
                            }
                        }
                    } label: {
                        TransactionAccountView(
                            viewType: .destination,
                            item: destination,
                            showAmount: true
                        )
                    }
                    .buttonStyle(.plain)
                    .environment(\.menuOrder, .fixed)
                    
                    HStack {
                        EnterAmountView(
                            symbol: source.currencySymbol,
                            isFocused: focusedField == .source,
                            value: $sourceAmount)
                        .onTapGesture {
                            focusedField = .source
                        }
                        
                        if destination.type.isAccount &&
                            source.currencyCode != destination.currencyCode {
                            Spacer()
                            EnterAmountView(
                                symbol: destination.currencySymbol,
                                isFocused: focusedField == .destination,
                                value: $destinationAmount)
                            .onTapGesture {
                                focusedField = .destination
                            }
                        }
                        
                    }
                    
                    
                    if let exchangeRate {
                        Text("Exchange rate: \(normalizedString(rate: exchangeRate))")
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                    }
                    
                }
                .padding()
                Spacer()
                
                CalculatorView(viewModel: CalculatorViewModel(showCalculator: false),
                               resultString: focusedField == .source ? $sourceAmount.onChange(updateDestinationAmount) : $destinationAmount.onChange(updateSourceAmount))
            }
            .navigationTitle(destination.type.isAccount ? "New transaction" : "New expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button( " Done ") {
                        makeTransfer()
                    }
                    .disabled(sourceAmount == "0")
                    .buttonStyle(DoneButtonStyle())
                }
            }
        }
    }
    
    private func normalizedString(rate: Double) -> String {
        let sourceSymbol = source.currencySymbol
        let destinationSymbol = destination.currencySymbol
        if rate > 1 {
            return rate.getString() + " " + destinationSymbol
        } else {
            return (1 / rate).getString() + " " + sourceSymbol
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
    
    private func updateRate(itemType: ItemType) {
        guard destination.type.isAccount else {
            exchangeRate = nil
            return
        }
        Task {
            exchangeRate = try await loadRates(
                sourceCode: source.currencyCode,
                destinationCode: destination.currencyCode) ??
            0
            switch itemType {
            case .source:
                updateSourceAmount(from: destinationAmount)
            case .destination:
                updateDestinationAmount(from: sourceAmount)
            }
        }
    }
    
    private func updateSourceAmount(from destination: String) {
        if let exchangeRate,
           exchangeRate > 0,
           let destination = Double(destination)
        {
            sourceAmount = (destination / exchangeRate).getString()
        } else {
            sourceAmount = "0"
        }
    }
    
    private func updateDestinationAmount(from source: String) {
        if let exchangeRate,
           exchangeRate > 0,
           let source = Double(source)
        {
            destinationAmount = (source * exchangeRate).getString()
        } else {
            destinationAmount = "0"
        }
    }
    
    private func loadRates(sourceCode: String, destinationCode: String) async throws -> Double? {
        let rates = try await currenciesApi.getExchangeRateFor(currencyCode: sourceCode)
        return rates.currency[sourceCode]?[destinationCode]
    }
}

private extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
