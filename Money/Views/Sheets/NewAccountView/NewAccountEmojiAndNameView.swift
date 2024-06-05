//
//  NewAccountEmojiAndNameView.swift
//  Money
//
//  Created by Artem on 18.05.2024.
//

import SwiftUI
import MCEmojiPicker

struct NewAccountEmojiAndNameView: View {
    var focusNameField = false
    @FocusState private var nameFieldIsFocused: Bool
    @Binding var account: Account
    @State private var isEmojiPickerPresented = false
    
    var body: some View {
        HStack {
            Button(account.icon) {
                isEmojiPickerPresented.toggle()
            }
            .font(.title)
            .padding(10)
            .background(Color(red: 0.98, green: 0.96, blue: 1))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .emojiPicker(
                isPresented: $isEmojiPickerPresented,
                selectedEmoji: $account.icon,
                arrowDirection: .up
            )
            .aspectRatio(1, contentMode: .fill)
            
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
