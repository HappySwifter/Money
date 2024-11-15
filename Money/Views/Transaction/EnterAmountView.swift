//
//  EnterAmountView.swift
//  Money
//
//  Created by Artem on 10.03.2024.
//

import SwiftUI

struct EnterAmountView: View {
    enum FocusedField {
        case none
        case amount
    }
    
    let symbol: String
    @State var isFocused: Bool
    @Binding var value: String
    @FocusState private var focusedField: FocusedField?

    var useTextField = false //TODO: do we really need this?
    
    var body: some View {
        HStack {
            Group {
                if useTextField {
                    Text(symbol)
                        .opacity(0.5)
                    TextField("", text: $value)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .amount)
                    
                } else {
                    Text(value)
                    Text(symbol)
                        .opacity(0.5)
                }
            }
            .font(.title2)
            Spacer()
        }
        .onAppear {
            focusedField = .amount
        }
        .dynamicTypeSize(.xLarge ... .xLarge)
        .padding()
        .frame(maxHeight: 50)
        .background(Color.gray.opacity(0.1))
        .contextMenu {
            if !useTextField {
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
        }
        .cornerRadiusWithBorder(radius: Constants.fieldCornerRadius,
                                borderLineWidth: isFocused ? 1 : 0)

    }
}
