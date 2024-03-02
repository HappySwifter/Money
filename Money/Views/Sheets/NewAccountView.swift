//
//  NewAccountView.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import SwiftUI
import MCEmojiPicker

struct NewAccountView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State var name = ""
    @State var currency = ""
    @State var selectedEmoji = "Shoose icon"
    @State var displayEmojiPicker: Bool = false
    
    @Binding var isSheetPresented: Bool
    @State private var isEmojiPickerPresented = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25, content: {
            HStack {
                Spacer()
                Button("Done") {
                    saveCategory()
                    isSheetPresented.toggle()
                }
                .buttonStyle(DoneButton())
            }
            TextField("Name", text: $name)
            TextField("Currency", text: $currency)
            Button(selectedEmoji) {
                isEmojiPickerPresented.toggle()
            }.emojiPicker(
                isPresented: $isEmojiPickerPresented,
                selectedEmoji: $selectedEmoji,
                arrowDirection: .down
            )
        })
        .font(.title)
    }
    
    func saveCategory() {
        let item = CircleItem(name: name, icon: selectedEmoji, type: .account)
        modelContext.insert(item)
    }
}

#Preview {
    NewAccountView(isSheetPresented: .constant(true))
}
