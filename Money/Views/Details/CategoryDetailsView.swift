//
//  CategoryDetailsView.swift
//  Money
//
//  Created by Artem on 03.03.2024.
//

import SwiftUI
import DataProvider

struct CategoryDetailsView: View {
    @Environment(ExpensesService.self) private var expensesService
    @Environment(\.dismiss) private var dismiss
    @Binding var isSheetPresented: Bool
    @State var category: Account
    @State private var icon: Icon?
        
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                HStack {
                    CategoryView(item: category, pressHandler: {_ in}, longPressHandler: {_ in} )
                        .frame(width: 100)
                    Spacer()
                }
                if let _ = icon {
                    IconAndNameView(account: $category, icon: Binding($icon)!)
                }
                NewAccountChooseColorView(account: $category, 
                                          isCategory: true)
                
//                Button("Delete") {
//                    withAnimation {
//                        modelContext.delete(category)
//                        try? expensesService.calculateSpent()
//                        dismiss()
//                    }
//                }
//                .buttonStyle(DeleteButton())
            }
            .padding()
        }
        .onAppear(perform: {
            self.icon = category.icon!
        })
        .onChange(of: icon) {
            category.icon = icon
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
