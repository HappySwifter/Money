//
//  NewCategoryView.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import SwiftUI
import MCEmojiPicker
import SwiftData

struct NewCategoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Preferences.self) private var preferences
    @Environment(CurrenciesApi.self) private var currenciesApi
    
    @Binding var isSheetPresented: Bool
    @State private var isEmojiPickerPresented = false
    
    @State var category = Account(orderIndex: 0,
                                  name: "",
                                  icon: "🏦",
                                  color: SwiftColor.allCases.randomElement()!,
                                  isAccount: false,
                                  amount: 0,
                                  currency: nil)
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 30, content: {
                    HStack {
                        CategoryView(item: category, pressHandler: {_ in}, longPressHandler: {_ in} )
                            .frame(width: 100)
                        Spacer()
                    }
                    
                    
                    HStack {
                        Button(category.icon) {
                            isEmojiPickerPresented.toggle()
                        }
                        .font(.title)
                        .padding(10)
                        .background(Color(red: 0.98, green: 0.96, blue: 1))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .emojiPicker(
                            isPresented: $isEmojiPickerPresented,
                            selectedEmoji: $category.icon,
                            arrowDirection: .up
                        )
                        .aspectRatio(1, contentMode: .fill)
                        
                        TextField("Name", text: $category.name)
                            .font(.title3)
                            .padding(15)
                            .background(Color(red: 0.98, green: 0.96, blue: 1))
                            .clipShape(RoundedRectangle(cornerRadius: 15.0))
                            .keyboardType(.asciiCapable)
                            .autocorrectionDisabled()
                            .scrollDismissesKeyboard(.interactively)
                    }
                    
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 50)), count: 6), alignment: .center) {
                            ForEach(SwiftColor.allCases, id: \.self) { color in
                                color.value
                                    .clipShape(Circle())
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                                    .opacity(category.color == color.rawValue ? 1 : 0.3)
                                    .onTapGesture {
                                        category.color = color.rawValue
                                    }
                            }
                        }
                    }
                })
                .padding()
            }
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        isSheetPresented.toggle()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveCategory()
                        isSheetPresented.toggle()
                    }
                    .disabled(category.name.isEmpty)
                }
            }
            .navigationTitle("New account")
        }
        
    }
    
    func saveCategory() {
        guard !category.name.isEmpty else {
            print("name is empty")
            return
        }
        do {
            let catDesc = FetchDescriptor<Account>()
            let catCount = try modelContext.fetchCount(catDesc)
            category.updateOrder(index: catCount)
            modelContext.insert(category)
        } catch {
            print(error)
        }

    }
}

#Preview {
    NewCategoryView(isSheetPresented: .constant(true))
}
