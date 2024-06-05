//
//  CategoryDetailsView.swift
//  Money
//
//  Created by Artem on 03.03.2024.
//

import SwiftUI

struct CategoryDetailsView: View {
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
                NewAccountEmojiAndNameView(account: $category)
                NewAccountChooseColorView(account: $category)
                
                Button("Delete") {
                    withAnimation {
                        modelContext.delete(category)
                        dismiss()
                    }
                }
                .buttonStyle(DeleteButton())
            }
            .padding()
        }
    }
}

//#Preview {
//    let item = SpendCategory(orderIndex: 0, name: "Dollar", icon: "", color: SwiftColor.purple)
//    return CategoryDetailsView(isSheetPresented: .constant(true), item: item)
//}
