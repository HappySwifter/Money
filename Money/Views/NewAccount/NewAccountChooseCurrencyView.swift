//
//  NewAccountChooseCurrencyView.swift
//  Money
//
//  Created by Artem on 18.05.2024.
//

import SwiftUI
import DataProvider

struct NewAccountChooseCurrencyView: View {
    @State private var isCurrencyPickerPresented = false
    @Binding var currency: MyCurrency?
    
    var body: some View {
        Button(currency?.symbol ?? "") {
            isCurrencyPickerPresented = true
        }
        .font(.title)
        .padding(10)
        .background(Color(red: 0.98, green: 0.96, blue: 1))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .sheet(isPresented: $isCurrencyPickerPresented, content: {
            NavigationStack {
                CurrencyPicker(selectedCurrency: Binding(get: {
                    currency!
                }, set: {
                    currency = $0
                }))
            }
        })
    }
}
