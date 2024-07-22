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
            var formatted = formatCardNumber(amount)
            amount = formatted
            if formatted.last == "." || formatted.last == "," {
                formatted = String(formatted.dropLast())
            }
            account.setInitial(amount: Double(formatted.replacingOccurrences(of: ",", with: ".")) ?? 0)
        })

        .font(.title3)
        .padding(15)
        .background(Color(red: 0.98, green: 0.96, blue: 1))
        .clipShape(RoundedRectangle(cornerRadius: 15.0))
        .keyboardType(.decimalPad)
        .scrollDismissesKeyboard(.interactively)
    }
    
    private func formatCardNumber(_ number: String) -> String {
        if number == "00" {
            return "0"
        } else if number.count > 1, !number.contains("."), !number.contains(","), number.first == "0" {
            return String(number.dropFirst())
        } else {
            return number
        }
    }
}
