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
                                          color: SwiftColor.clear.rawValue,
                                          isAccount: false,
                                          amount: 0,
                                          iconName: "basket.fill",
                                          iconColor: SwiftColor.categoryColors.first!.rawValue)
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 30) {
                IconAndNameView(focusNameField: true,
                                account: $category)
                ChooseColorView(account: $category)
                Spacer()
            }
            .padding()
            .navigationTitle("New category")
            .navigationBarTitleDisplayMode(.inline)
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
        }
        .dynamicTypeSize(.xLarge ... .xLarge)
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
