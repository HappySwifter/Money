//
//  CurrencyPicker.swift
//  Money
//
//  Created by Artem on 04.03.2024.
//

import SwiftUI
import SwiftData

struct CurrencyPicker: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var currencies: [Currency]
    
    @Binding var currency: Currency
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            
            Picker("Currency", selection: $currency) {
                TextField("Search", text: $searchText)
                    .font(.title3)
                    .foregroundStyle(Color.gray)
                ForEach(searchResults) { curr in
                    HStack {
                        Text(curr.name)
                            .font(.title3)
                    }
                    .tag(curr)
                }
            }
            .pickerStyle(.navigationLink)
            .onAppear(perform: {
                searchText = ""
            })
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

//#Preview(body: {
//    NavigationView {
//        CurrencyPicker(currency: .constant("nil"))
//    }
//    
//})
