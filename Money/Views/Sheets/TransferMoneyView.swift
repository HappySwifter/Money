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
    @Query(sort: \Account.date) private var accounts: [Account]
    @Query(sort: \SpendCategory.date) private var categories: [SpendCategory]
    
    @State var source: Transactionable
    @State var destination: Transactionable
    @Binding var isSheetPresented: Bool
    
    @State var exchangeRate: Double?
    @State private var amount = "0"
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Menu("\(source.icon) \(source.name)") {
                        switch source.type {
                        case .account:
                            CurrencyView(selectedItem: $source,
                                         accounts: accounts,
                                         categories: nil) {
                                updateRate()
                            }
                        case .category:
                            Color.clear
                        }
                    }
                    Text("-->")
                    
                    Menu("\(destination.icon) \(destination.name)") {
                        switch destination.type {
                        case .account:
                            CurrencyView(selectedItem: $destination,
                                         accounts: accounts,
                                         categories: nil) {
                                updateRate()
                            }
                            
                            Divider()
                            CurrencyView(selectedItem: $destination,
                                         accounts: nil,
                                         categories: categories) {
                                updateRate()
                            }
                        case .category:
                            CurrencyView(selectedItem: $destination,
                                         accounts: nil,
                                         categories: categories) {
                                updateRate()
                            }
                            Divider()
                            CurrencyView(selectedItem: $destination,
                                         accounts: accounts,
                                         categories: nil) {
                                updateRate()
                            }
                        }
                    }
                    .environment(\.menuOrder, .fixed)
                }
                
                HStack {
                    if let exchangeRate = exchangeRate {
                        Text("\(exchangeRate)")
                    }
                    Spacer()
                    Text(amount)
                        .font(.title)
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing)
                }
                .padding(.bottom)
                CalculatorView(viewModel: CalculatorViewModel(showCalculator: false), resultString: $amount)
                Spacer()
            }
            .padding()
            .navigationTitle(destination.type.isAccount ? "New transaction" : "New expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(" Done ") {
                        makeTransfer()
                        isSheetPresented.toggle()
                    }
                    .disabled(amount == "0")
                    .buttonStyle(DoneButtonStyle())
                }
            }
        }
    }
    
    private func makeTransfer() {
        guard let amount = Double(amount) else {
            assert(false)
            return
        }
        source.credit(amount: amount, to: destination)
        destination.deposit(amount: amount, from: source)
        
        let transaction = Transaction(amount: amount,
                                      sourceId: source.id,
                                      destination: destination.type)
        modelContext.insert(transaction)
    }
    
    private func updateRate() {
        guard destination.type.isAccount else {
            exchangeRate = nil
            return
        }
        Task {
            exchangeRate = try await loadRates(sourceCode: source.currencyCode,
                                               destinationCode: destination.currencyCode) ?? 0
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
