//
//  NewCategoryView.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import SwiftUI
import DataProvider
import OSLog

@MainActor
struct NewCategoryView: View {
    private let logger = Logger(subsystem: "Money", category: "NewCategoryView")
    @Environment(\.dataHandlerWithMainContext) private var dataHandlerMainContext
    @Environment(Preferences.self) private var preferences
    
    @Binding var isSheetPresented: Bool
    var isClosable = true
    var completion: (() -> Void)?
    
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
//                    AccountChooseColorView(account: $category,
//                                              isCategory: true)
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
                logger.error("\(error.localizedDescription)")
            }
        }
    }
}
