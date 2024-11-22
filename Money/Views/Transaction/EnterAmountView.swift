//
//  EnterAmountView.swift
//  Money
//
//  Created by Artem on 10.03.2024.
//

import SwiftUI

struct EnterAmountView: View {
    let symbol: String
    @State var isFocused: Bool
    @Binding var value: String
    @FocusState var isFocusedField: Bool
        
    var body: some View {
        HStack {
            Group {
                Text(symbol)
                    .opacity(0.5)
                TextField("", text: $value)
                    .keyboardType(.decimalPad)
                    .focused($isFocusedField)
                    .onChange(of: value, {
                        value = CurrencyStringModifier.formatAmount(value)
                    })
            }
            .font(.title2).monospaced()
            Spacer()
        }
        .onAppear {
            isFocusedField = true
        }
        .dynamicTypeSize(.xLarge ... .xLarge)
        .padding()
        .frame(maxHeight: 50)
        .background(Color.gray.opacity(0.1))
        .cornerRadiusWithBorder(radius: Constants.fieldCornerRadius,
                                borderLineWidth: isFocused ? 1 : 0)

    }
}
