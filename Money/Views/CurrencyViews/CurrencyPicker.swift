//
//  ItemPicker.swift
//  Money
//
//  Created by Artem on 06.03.2024.
//

import SwiftUI
import DataProvider

struct CurrencyPicker: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.dataHandlerWithMainContext) private var dataHandlerMainContext
    @Environment(CurrenciesManager.self) private var currenciesManager
    @State private var currencies = [AccountCurrency]()
    @State private var searchText = ""
    
    var initiallySelectedCurrency: AccountCurrency?
    var selectHandler: (AccountCurrency) -> Void
    var currenciesToShow = [AccountCurrency]()
    var isPresentedModally = true
    
    var body: some View {
        Form {
            ForEach(searchResults, id: \.code) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Text(item.code.uppercased())
                    if initiallySelectedCurrency == item {
                        Image(systemName: "checkmark")
                    }
                }
                .padding(10)
                .background(Color.gray.opacity(0.01))
                .onTapGesture {
                    selectHandler(item)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search")
        .task {
            searchText = ""
            currencies = currenciesManager.currencies
        }
        .toolbar {
            if isPresentedModally {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Close")
                    }
                }
            }
        }
        .navigationTitle("Select currency")
        .dynamicTypeSize(.xLarge ... .xLarge)
    }
    
    var searchResults: [AccountCurrency] {
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
