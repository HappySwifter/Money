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
    @State private var currencies = [CurrencyStruct]()
    @State private var searchText = ""
    
    var initiallySelectedCurrencyCode: String?
    var selectHandler: (CurrencyStruct) -> Void
    var isPresentedModally = true
    
    var body: some View {
        Form {
            ForEach(searchResults, id: \.code) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Text(item.code.uppercased())
                    if initiallySelectedCurrencyCode == item.code {
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
    
    var searchResults: [CurrencyStruct] {
        if searchText.isEmpty {
            return currencies
        } else {
            return currencies.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.code.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
