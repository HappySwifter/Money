//
//  AllCategoriesView.swift
//  Money
//
//  Created by Artem on 29.07.2024.
//

import SwiftUI
import DataProvider

@MainActor
struct AllCategoriesView: View {
    @Environment(\.dataHandlerWithMainContext) private var dataHandlerMainContext
    @Environment(ExpensesService.self) private var expensesService
    
    @State private var categories = [Account]()
    
    var body: some View {
        VStack {
            List {
                ForEach(categories) { cat in
                    NavigationLink {
                        CategoryDetailsView(category: cat, isPresentedModally: false)
                    } label: {
                        HStack {
                            IconView(icon: cat.icon)
                            Text(cat.name)
                            Spacer()
                        }
                    }
                    .accessibilityIdentifier(CategoriesDetailsViewLink)
                    .accessibilityIdentifier(CategoriesDetailsViewLink)
                }
                .onMove(perform: updateOrder)
                .onDelete(perform: deleteCategory)
            }
            Spacer()
        }
        .task {
            self.categories = await getCategories()
        }
        .toolbar {
            EditButton()
        }
        .navigationTitle("All categories")
    }
    
    private func getCategories() async -> [Account] {
        (try? await dataHandlerMainContext?.getCategories()) ?? []

    }
    
    private func deleteCategory(at offsets: IndexSet) {
        let dataHandler = dataHandlerMainContext
        Task { @MainActor in
            if let dataHandler = dataHandler {
                for i in offsets {
                    await dataHandler.hide(account: categories[i])
                }
                self.categories = await getCategories()
            }
        }
    }
    
    private func updateOrder(from: IndexSet, to: Int) {
        categories.move(fromOffsets: from, toOffset: to)
        for (index, item) in categories.enumerated() {
            item.updateOrder(index: index)
        }
    }
}

#Preview {
    AllCategoriesView()
}
