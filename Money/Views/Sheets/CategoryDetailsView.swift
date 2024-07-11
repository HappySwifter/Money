//
//  CategoryDetailsView.swift
//  Money
//
//  Created by Artem on 03.03.2024.
//

import SwiftUI

struct CategoryDetailsView: View {
    @Environment(ExpensesService.self) private var expensesService
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Binding var isSheetPresented: Bool
    @State var category: Account
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                HStack {
                    CategoryView(item: category, pressHandler: {_ in}, longPressHandler: {_ in} )
                        .frame(width: 100)
                    Spacer()
                }
                NewAccountEmojiAndNameView(account: $category, icon: Binding(get: {
                    category.icon!
                }, set: {
                    category.icon = $0
                }))
                NewAccountChooseColorView(account: $category)
                
                Button("Delete") {
                    withAnimation {
                        modelContext.delete(category)
                        try? expensesService.calculateSpent()
                        dismiss()
                    }
                }
                .buttonStyle(DeleteButton())
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Close") {
                    dismiss()
                }
            }
        }
    }
}

//#Preview {
//    let item = SpendCategory(orderIndex: 0, name: "Dollar", icon: "", color: SwiftColor.purple)
//    return CategoryDetailsView(isSheetPresented: .constant(true), item: item)
//}
