//
//  NewAccountAmountView.swift
//  Money
//
//  Created by Artem on 18.05.2024.
//

import SwiftUI
import DataProvider

struct NewAccountAmountView: View {
    @Binding var account: Account
    @State private var amount = "0"
    
    var body: some View {
        TextField("placeholder", text: $amount)
        .onChange(of: amount, {
            amount = CurrencyStringModifier.formatAmount(amount)
            account.setInitial(amount: amount)
        })

        .font(.title3)
        .padding(15)
        .cornerRadiusWithBorder(radius: Constants.fieldCornerRadius)
        .keyboardType(.decimalPad)
        .scrollDismissesKeyboard(.interactively)
    }
}
