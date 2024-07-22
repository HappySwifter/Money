//
//  AccountDetailsView.swift
//  Money
//
//  Created by Artem on 03.03.2024.
//

import SwiftUI
import DataProvider

struct AccountDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ExpensesService.self) private var expensesService
    @State var account: Account
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                AccountView(item: account,
                            currency: .constant(account.currency),
                            selected: .constant(false),
                            longPressHandler: nil)
                IconAndNameView(account: $account, icon: Binding(get: {
                    account.icon!
                }, set: {
                    account.icon = $0
                }))
                NewAccountChooseColorView(account: $account, isCategory: false)
                
                Spacer()
//                Button("Delete") {
//                    withAnimation {
//                        modelContext.delete(account)
//                        try? expensesService.calculateSpent()
//                        dismiss()
//                    }
//                }
//                .buttonStyle(DeleteButton())
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
