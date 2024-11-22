//
//  NewAccountChooseCurrencyView.swift
//  Money
//
//  Created by Artem on 18.05.2024.
//

import SwiftUI
import DataProvider

struct NewAccountChooseCurrencyView: View {
    //    @State private var isCurrencyPickerPresented = false
    @Binding var currency: AccountCurrency?
    
    var body: some View {
        NavigationLink(destination: MyCurrenciesView(selectedCurrency: $currency)) {
            Text(currency?.symbol ?? "")
                .font(.title)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .cornerRadiusWithBorder(radius: Constants.fieldCornerRadius)
        }
        
    }
}
