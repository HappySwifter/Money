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
        
    @Binding var isPresented: Bool
    @Binding var selectedCurrencyCode: String
    @State private var searchText = ""
    @State var currencies = [Currency]()
    
    var body: some View {
        Form {
            ForEach(searchResults, id: \.code) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Text(item.code)
                }
                .onTapGesture {
                    selectedCurrencyCode = item.code
                    isPresented.toggle()
                }
            }
        }
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
            return currencies
        } else {
            return currencies.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}
