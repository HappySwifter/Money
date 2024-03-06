//
//  CategoryDetailsView.swift
//  Money
//
//  Created by Artem on 03.03.2024.
//

import SwiftUI

struct CategoryDetailsView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isSheetPresented: Bool
    let item: SpendCategory
    
    var body: some View {
        Text("Details: \(item.name)")
        Button("Delete") {
            withAnimation {
                modelContext.delete(item)
                isSheetPresented = false
            }
        }
        .buttonStyle(DeleteButton())
    }
}

#Preview {
    let item = SpendCategory(name: "Dollar", icon: "", color: SwiftColor.purple)
    return CategoryDetailsView(isSheetPresented: .constant(true), item: item)
}
