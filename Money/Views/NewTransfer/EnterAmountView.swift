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
                .font(.title2)
            Text(symbol)
                .opacity(0.5)
                .font(.title2)

            Spacer()
        }
        .dynamicTypeSize(.xSmall ... .accessibility3)
        .padding()
        .frame(maxHeight: 50)
        .background(Color.gray.opacity(0.1))
        .contextMenu {
            Button("Paste") {
                let pasteString = UIPasteboard.general.string ?? ""
                if let double = Double(pasteString), double > 0 {
                    value = pasteString
                } else if let double = pasteString.toDouble(), double > 0 {
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
