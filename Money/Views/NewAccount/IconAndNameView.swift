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
                SymbolPickerView(canChooseColor: !account.isAccount, selectedIcon: $icon)
            } label: {
                IconView(icon: icon, font: .title)
                    .padding(10)
                    .frame(maxHeight: .infinity)
                    .cornerRadiusWithBorder(radius: 15)
                    

            }
            .accessibilityIdentifier(SymbolPickerViewLink)
            
            TextField("Name", text: $account.name)
                .font(.title3)
                .padding(15)
                .scrollDismissesKeyboard(.interactively)
                .focused($nameFieldIsFocused)
                .frame(maxHeight: .infinity)
                .cornerRadiusWithBorder(radius: 15)
        }
        .fixedSize(horizontal: false, vertical: true)
        .onAppear {
            nameFieldIsFocused = focusNameField
        }
    }
}
