//
//  CategoryDetailsView.swift
//  Money
//
//  Created by Artem on 03.03.2024.
//

import SwiftUI

struct CategoryDetailsView: View {
    @Environment(\.modelContext) private var modelContext
    let item: CircleItem
    
    var body: some View {
        Text("Details: \(item.name)")
        Button("Delete") {
            withAnimation {
                modelContext.delete(item)
            }
        }
        .buttonStyle(DeleteButton())
    }
}

#Preview {
    CategoryDetailsView(item: CircleItem(name: "test", type: .category))
}
