//
//  NewCategoryView.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import SwiftUI
import DataProvider

@MainActor
struct NewCategoryView: View {
    @Environment(\.dataHandlerWithMainContext) private var dataHandlerMainContext
    @Environment(Preferences.self) private var preferences
    
    @Binding var isSheetPresented: Bool
    var isClosable = true
    var completion: (() -> ())?

    @State private var isEmojiPickerPresented = false
    
    @State private var category = Account(orderIndex: 0,
                                  name: "",
                                  color: SwiftColor.clear,
                                  isAccount: false,
                                  amount: 0)
    @State private var icon = Icon(name: "basket.fill", color: SwiftColor.green, isMulticolor: true)

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    HStack {
                        CategoryView(item: category, pressHandler: {_ in}, longPressHandler: {_ in} )
                            .frame(width: 100)
                        Spacer()
                    }
                    IconAndNameView(focusNameField: true,
                                               account: $category,
                                               icon: $icon)
                    NewAccountChooseColorView(account: $category,
                                              isCategory: true)
                }
                .padding()
            }
            .onAppear {
                category.icon = icon
            }
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                if isClosable {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") {
                            isSheetPresented.toggle()
                        }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveCategory()
                        completion?()
                        isSheetPresented.toggle()
                    }
                    .disabled(category.name.isEmpty)
                }
            }
            .navigationTitle("New category")
        }
        
    }
    
    func saveCategory() {
        guard !category.name.isEmpty else {
            print("name is empty")
            return
        }
        Task { @MainActor in
            do {
                if let dataHandler = await dataHandlerMainContext() {
                    let catCount = try await dataHandler.getCategoriesCount()
                    category.updateOrder(index: catCount)
                    await dataHandler.new(account: category)
                }
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    NewCategoryView(isSheetPresented: .constant(true))
}
