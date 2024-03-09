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
    var currenciesToShow = [Currency]()
    
    var body: some View {
        Form {
            ForEach(searchResults, id: \.code) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    if selectedCurrency == item {
                        Image(systemName: "checkmark")
                    }
                }
                .background(Color.gray.opacity(0.01))
                .onTapGesture {
                    selectedCurrency = item
                    presentationMode.wrappedValue.dismiss()
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
            return currenciesToShow.isEmpty ? currencies : currenciesToShow
        } else {
            let temp = currenciesToShow.isEmpty ? currencies : currenciesToShow
            return temp.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.code.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
