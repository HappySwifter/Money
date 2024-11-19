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
    
    @Binding var selectedCurrency: MyCurrency
    @State private var searchText = ""
    @State var currencies = [MyCurrency]()
    var currenciesToShow = [MyCurrency]()
    
    var body: some View {
        NavigationStack {
            Form {
                ForEach(searchResults, id: \.code) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        if selectedCurrency == item {
                            Image(systemName: "checkmark")
                        }
                    }
                    .padding(10)
                    .background(Color.gray.opacity(0.01))
                    .onTapGesture {
                        selectedCurrency = item
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
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Close")
                    }

                }
            }
        }
        .dynamicTypeSize(.xLarge ... .xLarge)
    }
    
    var searchResults: [MyCurrency] {
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
