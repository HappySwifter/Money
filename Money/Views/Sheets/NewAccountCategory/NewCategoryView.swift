//
//  NewCategoryView.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import SwiftUI
import SwiftData

struct NewCategoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Preferences.self) private var preferences
    @Environment(CurrenciesApi.self) private var currenciesApi
    
    @Binding var isSheetPresented: Bool
    @State private var isEmojiPickerPresented = false
    
    @State var category = Account(orderIndex: 0,
                                  name: "",
                                  color: SwiftColor.allCases.randomElement()!,
                                  isAccount: false,
                                  amount: 0)
    @State var icon = Icon(name: "basket.fill", color: .green, isMulticolor: true)

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    HStack {
                        CategoryView(item: category, pressHandler: {_ in}, longPressHandler: {_ in} )
                            .frame(width: 100)
                        Spacer()
                    }
                    NewAccountEmojiAndNameView(focusNameField: true,
                                               account: $category,
                                               icon: $icon)
                    NewAccountChooseColorView(account: $category)
                }
                .padding()
            }
            .onAppear {
                category.icon = icon
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
            .navigationTitle("New category")
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
