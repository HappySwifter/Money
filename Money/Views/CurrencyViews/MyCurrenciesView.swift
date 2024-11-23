//
//  MyCurrenciesView.swift
//  Money
//
//  Created by Artem on 22.11.2024.
//

import SwiftUI
import SwiftData
import DataProvider

struct MyCurrenciesView: View {
    @Environment(\.dataHandlerWithMainContext) private var dataHandler
    @Environment(\.dismiss) private var dismiss
    @Query private var currencies: [MyCurrency]
    @State private var isExchangeRateViewPresented = false
    @State private var newCurrencyToAdd: CurrencyStruct?
    
    @Binding var selectedCurrencyCode: String?
    
    var body: some View {
        VStack {
            List(currencies) { currency in
                VStack(alignment: .leading) {
                    HStack {
                        Text(currency.name)
                        Spacer()
                        Text(currency.code.uppercased())
                    }
                    .padding(.vertical)
                    if currency.isBase {
                        Text("Base currency")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                }
                .background(Color.gray.opacity(0.01))
                .onTapGesture {
                    selectedCurrencyCode = currency.code
                    dismiss()
                }
            }
        }
        .navigationTitle("My Currencies")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(
                    destination: CurrencyPicker(
                        initiallySelectedCurrencyCode: selectedCurrencyCode,
                        selectHandler: currencyPickerSelectHandler,
                        isPresentedModally: false)) {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
        .popover(isPresented: $isExchangeRateViewPresented) {
            if let newCurrencyToAdd {
                ExchangeRateView(
                    newCurrency: newCurrencyToAdd,
                    completion: exchangeRateSelectHandler(rate:))
            }
        }
    }
    
    private func currencyPickerSelectHandler(currency: CurrencyStruct) {
        selectedCurrencyCode = currency.code
        if !currencies.contains(where: { $0.code == currency.code }) {
            newCurrencyToAdd = currency
            isExchangeRateViewPresented = true
        }
    }
    
    private func exchangeRateSelectHandler(rate: Double) {
        guard let newCurrencyToAdd else { return }
        let newCurrency = MyCurrency(name: newCurrencyToAdd.name,
                                     code: newCurrencyToAdd.code,
                                     symbol: newCurrencyToAdd.symbol,
                                     rateToBaseCurrency: rate,
                                     isBase: false)
        Task {
            try await dataHandler?.new(currency: newCurrency)
        }
        dismiss()
    }
}

#Preview {
    MyCurrenciesView(selectedCurrencyCode: .constant(""))
}
