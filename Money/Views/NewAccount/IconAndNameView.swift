//
//  NewAccountEmojiAndNameView.swift
//  Money
//
//  Created by Artem on 18.05.2024.
//

import SwiftUI
import DataProvider

struct IconAndNameView: View {
    var focusNameField = false
    @FocusState private var nameFieldIsFocused: Bool
    @Binding var account: Account
    @Binding var icon: Icon
    
    var body: some View {
        HStack {
            NavigationLink {
                SymbolPickerView(selectedIcon: $icon)
            } label: {
                IconView(icon: icon, font: .title)
                    .padding(10)
                    .background(Color(red: 0.98, green: 0.96, blue: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .aspectRatio(1, contentMode: .fill)
            }
            .accessibilityIdentifier(SymbolPickerViewLink)
            
            TextField("Name", text: $account.name)
                .font(.title3)
                .padding(15)
                .background(Color(red: 0.98, green: 0.96, blue: 1))
                .clipShape(RoundedRectangle(cornerRadius: 15.0))
                .keyboardType(.asciiCapable)
                .autocorrectionDisabled()
                .scrollDismissesKeyboard(.interactively)
                .focused($nameFieldIsFocused)
        }
        .onAppear {
            nameFieldIsFocused = focusNameField
        }
    }
}
