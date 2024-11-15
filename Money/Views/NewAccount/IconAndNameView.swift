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
        
    var body: some View {
        HStack {
            NavigationLink {
                SymbolPickerView(selectedIcon: Binding(projectedValue: $account.icon))
            } label: {
                IconView(icon: account.icon, font: .title)
                    .padding(10)
                    .frame(maxHeight: .infinity)
                    .cornerRadiusWithBorder(radius: Constants.fieldCornerRadius)
            }
            .accessibilityIdentifier(SymbolPickerViewLink)
            
            TextField("Name", text: $account.name)
                .font(.title3)
                .padding(15)
                .scrollDismissesKeyboard(.interactively)
                .focused($nameFieldIsFocused)
                .frame(maxHeight: .infinity)
                .cornerRadiusWithBorder(radius: Constants.fieldCornerRadius)
        }
        .fixedSize(horizontal: false, vertical: true)
        .onAppear {
            nameFieldIsFocused = focusNameField
        }
    }
}
