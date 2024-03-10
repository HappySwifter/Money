//
//  EnterAmountView.swift
//  Money
//
//  Created by Artem on 10.03.2024.
//

import SwiftUI

struct EnterAmountView: View {
    let symbol: String
    @Binding var value: String
    
    var body: some View {
        HStack {
            Spacer()
            TextField("0", text: $value)
                .font(.title2)
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
                .fixedSize()
                
            Text(symbol)
                .foregroundStyle(Color.gray.opacity(0.5))
                .font(.title2)
            Spacer()
        }
    }
}
