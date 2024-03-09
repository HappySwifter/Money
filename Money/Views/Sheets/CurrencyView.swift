//
//  CurrencyView.swift
//  Money
//
//  Created by Artem on 09.03.2024.
//

import SwiftUI

struct CurrencyView: View {
    @Binding var selectedItem: Transactionable
    let accounts: [Account]?
    let categories: [SpendCategory]?
    var changeHandler: (() -> ())
    
    var body: some View {
        if let accounts = accounts {
            Text("Accounts")
            ForEach(accounts) { acc in
                Button {
                    selectedItem = acc
                    changeHandler()
                } label: {
                    HStack {
                        Text("\(acc.icon) \(acc.name)")
                        Spacer()
                        if selectedItem.name == acc.name && selectedItem.type.isSameType(with: acc.type) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } else if let categories = categories {
            Text("Categories")
            ForEach(categories) { acc in
                Button {
                    selectedItem = acc
                    changeHandler()
                } label: {
                    HStack {
                        Text("\(acc.icon) \(acc.name)")
                        Spacer()
                        if selectedItem.name == acc.name && selectedItem.type.isSameType(with: acc.type) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        }
    }
}

//#Preview {
//    CurrencyView(item: <#Transactionable#>)
//}
