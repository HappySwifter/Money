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

#Preview {
    VStack {
        IconAndNameView(account: .constant(Account(orderIndex: 0, name: "Bank", color: .blue, isAccount: true, amount: 1000)), icon: .constant(Icon(name: "banknote", color: .green, isMulticolor: true)))
        
        IconAndNameView(account: .constant(Account(orderIndex: 0, name: "Bank", color: .blue, isAccount: true, amount: 1000)), icon: .constant(Icon(name: "shoe", color: .green, isMulticolor: true)))
        
        IconAndNameView(account: .constant(Account(orderIndex: 0, name: "Bank", color: .blue, isAccount: true, amount: 1000)), icon: .constant(Icon(name: "basket", color: .green, isMulticolor: true)))
        
        IconAndNameView(account: .constant(Account(orderIndex: 0, name: "Bank", color: .blue, isAccount: true, amount: 1000)), icon: .constant(Icon(name: "fork.knife", color: .green, isMulticolor: true)))
    }
}
