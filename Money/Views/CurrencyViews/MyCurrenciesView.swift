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
//    @Environment(\.dataHandlerWithMainContext) private var dataHandler
    @Query private var currencies: [MyCurrency]
    @State private var isExchangeRateViewPresented = false
    @Binding var selectedCurrency: AccountCurrency?

    var body: some View {
        VStack {
            List {
                ForEach(currencies) { currency in
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
                }
            }
        }
        .navigationTitle("My Currencies")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(
                    destination: CurrencyPicker(initiallySelectedCurrency: selectedCurrency,
                                                selectHandler: pickerSelectHandler,
                                                isPresentedModally: false)) {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
        .popover(isPresented: $isExchangeRateViewPresented) {
            if let selectedCurrency {
                ExchangeRateView(newCurrency: selectedCurrency)
            }
        }
    }
    
    private func pickerSelectHandler(currency: AccountCurrency) {
        selectedCurrency = currency
        isExchangeRateViewPresented.toggle()
    }
}

#Preview {
    MyCurrenciesView(selectedCurrency: .constant(nil))
}
