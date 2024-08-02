//
//  CategoryDetailsView.swift
//  Money
//
//  Created by Artem on 03.03.2024.
//

import SwiftUI
import DataProvider

@MainActor
struct CategoryDetailsView: View {
    @Environment(ExpensesService.self) private var expensesService
    @Environment(\.dataHandlerWithMainContext) private var dataHandlerMainContext
    @Environment(\.dismiss) private var dismiss
    @State var category: Account
    var isPresentedModally = true
        
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                HStack {
                    CategoryView(item: category, 
                                 presentingType: .constant(.none))
                        .frame(width: 100)
                    Spacer()
                }
                IconAndNameView(account: $category,
                                icon: Binding($category.icon)!)

                Button("Hide cattegory") {
                    withAnimation {
                        deleteCategory()
                        dismiss()
                    }
                }
                .buttonStyle(DeleteButton())
            }
            .padding()
        }
        .toolbar {
            if isPresentedModally {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func deleteCategory() {
        let dataHandler = dataHandlerMainContext
        Task { @MainActor in
            await dataHandler()?.hide(account: category)
        }
    }
}
