//
//  ExchangeRateView.swift
//  Money
//
//  Created by Artem on 22.11.2024.
//

import SwiftUI
import SwiftData
import DataProvider
import OSLog

struct ExchangeRateView: View {
    private let logger = Logger(subsystem: "Money", category: #file)
    @Environment(\.dataHandlerWithMainContext) private var dataHandler
    @Environment(ExpensesService.self) private var expensesService
    @Environment(\.dismiss) private var dismiss
    @State private var baseCurrency: MyCurrency?
    @State private var newCurrencyRate = 0.0
    @State private var isInverted = false
    
    let newCurrency: AccountCurrency
    
    private var rateBinding: Binding<String> {
        Binding(get: {
            if isInverted {
                return prettify(val: 1 / newCurrencyRate, fractionLength: 4)
            } else {
                return prettify(val: newCurrencyRate, fractionLength: 4)
            }
        }, set: { val in
            if isInverted {
                newCurrencyRate =  1 / (val.toDouble() ?? 1)
            } else {
                newCurrencyRate = val.toDouble() ?? 0
            }
        })
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if let baseCurrency {
                    HStack {
                        Text(isInverted ? newCurrency.symbol : baseCurrency.symbol)
                            .opacity(0.5)
                        Text("1")
                    }
                    .font(.title2).monospaced()
                    
                    Button {
                        isInverted.toggle()
                        updateRate()
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .padding()
                            .font(.title)
                    }
                    
                    EnterAmountView(symbol: isInverted ? baseCurrency.symbol : newCurrency.symbol,
                                    isFocused: true,
                                    value: rateBinding)
                    Spacer()
                }
            }
            .padding()
            .task {
                do {
                    baseCurrency = try await dataHandler?.getBaseCurrency()
                } catch let error as DataProviderError {
                    logger.error("\(error.rawValue)")
                    assert(false)
                } catch {
                    logger.error("\(error.localizedDescription)")
                }
                updateRate()
            }
            .navigationTitle("Exchange rate")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button {
                        saveMyCurrencyAndClose()
                    } label: {
                        Text("Create")
                    }
                    
                }
            }
        }
    }
    
    private func updateRate() {
        guard let baseCurrency else { return }
        Task {
            do {
                let rates = try await expensesService.getTodayExchangeRateFor(currencyCode: baseCurrency.code)
                newCurrencyRate = rates.value(for: newCurrency.code) ?? 1
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    private func saveMyCurrencyAndClose() {
        let newCurrency = MyCurrency(name: newCurrency.name,
                                     code: newCurrency.code,
                                     symbol: newCurrency.symbol,
                                     rateToBaseCurrency: newCurrencyRate,
                                     isBase: false)
        Task {
            try await dataHandler?.new(currency: newCurrency)
        }
        dismiss()
    }
}

#Preview(traits: .sampleData) {
    let new = AccountCurrency(code: "usd", name: "US Dollar", symbol: "$")
    ExchangeRateView(newCurrency: new)
        .environment(\.dataHandlerWithMainContext, DataHandler(modelContainer: DataProvider.shared.sharedModelContainer, mainActor: true))
}
