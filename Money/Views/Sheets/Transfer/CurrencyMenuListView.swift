//
//  CurrencyView.swift
//  Money
//
//  Created by Artem on 09.03.2024.
//

import SwiftUI

struct CurrencyMenuListView: View {
    @Binding var selectedItem: Transactionable
    let accounts: [Account]?
    let categories: [SpendCategory]?
    var changeHandler: ((_ oldValue: Transactionable) -> ())
        
    var body: some View {
        Group {
            if let accounts = accounts {
                Text("Accounts")
                ForEach(accounts) { acc in
                    Button {
                        let oldValue = selectedItem
                        withAnimation {
                            selectedItem = acc
                        }
                        
                        changeHandler(oldValue)
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
                        let oldValue = selectedItem
                        withAnimation {
                            selectedItem = acc
                        }
                        changeHandler(oldValue)
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
}

//#Preview {
//    CurrencyView(item: <#Transactionable#>)
//}
