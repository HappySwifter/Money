//
//  ItemPicker.swift
//  Money
//
//  Created by Artem on 06.03.2024.
//

import SwiftUI
import SwiftData

struct CurrencyPicker: View {
    @Environment(CurrenciesApi.self) private var currenciesApi
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var selectedCurrency: Currency
    @State private var searchText = ""
    @State var currencies = [Currency]()
    var showOnlyCurrencies = [Currency]()
    
    var body: some View {
        NavigationStack {
            Form {
                ForEach(searchResults, id: \.code) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text(item.code)
                    }
                    .background(Color.gray.opacity(0.01))
                    .onTapGesture {
                        selectedCurrency = item
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search")
        .onAppear {
            searchText = ""
            do {
                currencies = try currenciesApi.getCurrencies()
            } catch {
                print(error)
            }
            
        }
    }
    
    var searchResults: [Currency] {
        if searchText.isEmpty {
            if showOnlyCurrencies.isEmpty {
                return currencies
            } else {
                return showOnlyCurrencies
            }
            
        } else {
            if showOnlyCurrencies.isEmpty {
                return currencies.filter {
                    $0.name.lowercased().contains(searchText.lowercased()) ||
                    $0.code.lowercased().contains(searchText.lowercased())
                }
            } else {
                return showOnlyCurrencies.filter {
                    $0.name.lowercased().contains(searchText.lowercased()) ||
                    $0.code.lowercased().contains(searchText.lowercased())
                }
            }
        }
    }
}
