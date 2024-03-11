//
//  EnterAmountView.swift
//  Money
//
//  Created by Artem on 10.03.2024.
//

import SwiftUI

struct EnterAmountView: View {
    let symbol: String
    let isFocused: Bool
    @Binding var value: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(value)
            
            Text(symbol)
                .foregroundStyle(Color.gray.opacity(0.5))
                .font(.title2)

            Spacer()
        }
        .padding()
        .frame(maxHeight: 50)
        .background(Color.gray.opacity(0.1))
        .contextMenu {
            Button("Paste") {
                let pasteString = UIPasteboard.general.string ?? ""
                if let double = Double(pasteString), double > 0 {
                    value = pasteString
                }
            }
            Button("Copy") {
                UIPasteboard.general.string = value
            }
        }
        .cornerRadiusWithBorder(radius: 10, borderLineWidth: isFocused ? 1 : 0)

    }
}
