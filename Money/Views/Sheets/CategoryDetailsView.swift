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
    let category: Account
    
    var body: some View {
        VStack {
            Text("Details: \(category.name)")
            Button("Delete") {
                withAnimation {
                    category.isHidden = true
                    isSheetPresented = false
                }
            }
            .buttonStyle(DeleteButton())
        }
        .padding()
    }
}

//#Preview {
//    let item = SpendCategory(orderIndex: 0, name: "Dollar", icon: "", color: SwiftColor.purple)
//    return CategoryDetailsView(isSheetPresented: .constant(true), item: item)
//}
