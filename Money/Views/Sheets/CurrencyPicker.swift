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
            .onAppear {
                searchText = ""
                do {
                    currencies = try currenciesApi.getCurrencies()
                } catch {
                    print(error)
                }
                
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
