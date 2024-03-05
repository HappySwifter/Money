//
//  AccountDetailsView.swift
//  Money
//
//  Created by Artem on 03.03.2024.
//

import SwiftUI

struct AccountDetailsView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isSheetPresented: Bool
    let item: CircleItem
    
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
    AccountDetailsView(isSheetPresented: .constant(true), item: CircleItem(name: "test", currency: Currency(code: "usd", name: "US Dollar", icon: "$"), type: .account, color: SwiftColor.purple))
}
