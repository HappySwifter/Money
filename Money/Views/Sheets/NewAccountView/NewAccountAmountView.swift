//
//  NewAccountAmountView.swift
//  Money
//
//  Created by Artem on 18.05.2024.
//

import SwiftUI

struct NewAccountAmountView: View {
    @Binding var account: Account
    
    var body: some View {
        TextField("Amount", text: Binding(get: {
            String(format: "%.0f", account.amount)
        }, set: {
            account.setInitial(amount: Double($0) ?? 0)
        }))
        .font(.title3)
        .padding(15)
        .background(Color(red: 0.98, green: 0.96, blue: 1))
        .clipShape(RoundedRectangle(cornerRadius: 15.0))
        .keyboardType(.decimalPad)
        .scrollDismissesKeyboard(.interactively)
    }
}
