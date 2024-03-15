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
    
    let accountPredicate = #Predicate<Account> { acc in
        acc.isAccount
    }
    
    @Query(filter: #Predicate<Account> { $0.isAccount },
           sort: \Account.orderIndex)
    private var accounts: [Account]
    
    @Query(
        filter: #Predicate<Account> { !$0.isAccount },
        sort: \Account.orderIndex)
    private var categories: [Account]
    
    @State var source: Account
    @State var destination: Account
    @Binding var isSheetPresented: Bool
    
    @State private var exchangeRate: Double?
    @State private var sourceAmount = "0"
    @State private var destinationAmount = "0"
    
    enum ItemType: Hashable {
        case source
        case destination
        
        var title: String {
            switch self {
            case .source:
                return "From"
            case .destination:
                return "To"
            }
        }
    }
    @State private var focusedField = ItemType.source
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 15) {
                    HStack {
                        Menu {
                            Text("Accounts")
                            CurrencyMenuListView(selectedItem: $source, data: accounts) {
                                swapItemsIfNeededAndUpdateRate(oldValue: $0, changedItemType: ItemType.source)
                            }
                        } label: {
                            TransactionAccountView(
                                viewType: ItemType.source,
                                item: source,
                                showAmount: destination.isAccount
                            )
                        }
                        .buttonStyle(.plain)
                        .environment(\.menuOrder, .fixed)
                        
                        Menu {
                            if destination.isAccount {
                                Text("Accounts")
                                CurrencyMenuListView(selectedItem: $destination, data: accounts) {
                                    swapItemsIfNeededAndUpdateRate(oldValue: $0, changedItemType: .destination)
                                }
                                Divider()
                                Text("Categories")
                                CurrencyMenuListView(selectedItem: $destination, data: categories) {
                                    swapItemsIfNeededAndUpdateRate(oldValue: $0, changedItemType: .destination)
                                }
                            } else {
                                Text("Categories")
                                CurrencyMenuListView(selectedItem: $destination, data: categories) {
                                    swapItemsIfNeededAndUpdateRate(oldValue: $0, changedItemType: .destination)
                                }
                                Divider()
                                Text("Accounts")
                                CurrencyMenuListView(selectedItem: $destination, data: accounts) {
                                    swapItemsIfNeededAndUpdateRate(oldValue: $0, changedItemType: .destination)
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
                    }
                    HStack {
                        EnterAmountView(
                            symbol: source.currency?.symbol ?? "",
                            isFocused: focusedField == .source,
                            value: $sourceAmount)
                        .onTapGesture {
                            focusedField = .source
                        }
                        
                        if destination.isAccount,
                            source.currency?.code != destination.currency?.code {
                            Spacer()
                            EnterAmountView(
                                symbol: destination.currency?.symbol ?? "",
                                isFocused: focusedField == .destination,
                                value: $destinationAmount)
                            .onTapGesture {
                                focusedField = .destination
                            }
                        }
                    }
                    
                    if let exchangeRate, (source.currency?.code != destination.currency?.code) {
                        Text("Exchange rate: \(normalizedString(rate: exchangeRate))")
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                    }
                }
                .padding()
                Spacer()
                
                
                HStack {
                    Spacer()
                    Button(" Done ") {
                        makeTransfer()
                    }
                    .disabled(sourceAmount.toDouble() == 0)
                    .buttonStyle(DoneButtonStyle())
                }
                .padding(.horizontal)
                
                CalculatorView(viewModel: CalculatorViewModel(showCalculator: false),
                               resultString: focusedField == .source ? $sourceAmount.onChange(updateDestinationAmount) : $destinationAmount.onChange(updateSourceAmount))
            }
            .navigationTitle(destination.isAccount ? "New transaction" : "New expense")
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
    
    private func normalizedString(rate: Double) -> String {
        let sourceSymbol = source.currency?.symbol ?? ""
        let destinationSymbol = destination.currency?.symbol ?? ""
        if rate > 1 {
            return rate.getString() + " " + destinationSymbol
        } else {
            return (1 / rate).getString() + " " + sourceSymbol
        }
    }
    
    private func makeTransfer() {
        var amount = sourceAmount
        if amount.last == "," {
            amount = String(amount.dropLast())
        }
        guard let amount = amount.toDouble(), amount > 0 else {
            assert(false)
            return
        }
        guard source.credit(amount: amount) else {
            return
        }
        if destination.isAccount {
            destination.deposit(amount: amount)
        }
        let transaction = Transaction(sourceAmount: amount,
                                      source: source,
                                      destinationAmount: destinationAmount.toDouble(),
                                      destination: destination)
        modelContext.insert(transaction)
        isSheetPresented.toggle()
    }
    
    private func swapItemsIfNeededAndUpdateRate(
        oldValue: Account,
        changedItemType: ItemType)
    {
        if source.id == destination.id {
            if oldValue.isAccount {
                // swaping
                switch changedItemType {
                case .source: destination = oldValue
                case .destination: source = oldValue
                }
            } else {
                // restoring old state
                switch changedItemType {
                case .source: source = oldValue
                case .destination: destination = oldValue
                }
            }
        }
        if destination.isAccount {
            updateRate()
        } else {
            focusedField = .source
            destinationAmount = "0"
            exchangeRate = nil
        }
    }
    
    private func updateRate() {
        guard let sourceCode = source.currency?.code,
              let destCode = destination.currency?.code else {
            return
        }
        Task {
            exchangeRate = try await loadRates(
                sourceCode: sourceCode,
                destinationCode: destCode) ?? 0

                updateDestinationAmount(from: sourceAmount)
        }
    }
    
    private func updateSourceAmount(from destination: String) {
        if let exchangeRate,
           exchangeRate > 0,
           let destination = destination.toDouble()
        {
            sourceAmount = (destination / exchangeRate).getString()
        } else {
            sourceAmount = "0"
        }
    }
    
    private func updateDestinationAmount(from source: String) {
        if let exchangeRate,
           exchangeRate > 0,
           let source = source.toDouble()
        {
            destinationAmount = (source * exchangeRate).getString()
        } else {
            destinationAmount = "0"
        }
    }
    
    private func loadRates(sourceCode: String, destinationCode: String) async throws -> Double? {
        let rates = try await currenciesApi.getExchangeRateFor(currencyCode: sourceCode, date: Date())
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
