//
//  CurrencyView.swift
//  Money
//
//  Created by Artem on 09.03.2024.
//

import SwiftUI
import DataProvider

struct CurrencyMenuListView: View {
    @Binding var selectedItem: Account
    let data: [Account]
    var changeHandler: ((_ oldValue: Account) -> Void)?
        
    var body: some View {
        ForEach(data) { acc in
            Button {
                let oldValue = selectedItem
                withAnimation {
                    selectedItem = acc
                }
                changeHandler?(oldValue)
            } label: {
                HStack {
                    if selectedItem.name == acc.name && selectedItem.isSameType(with: acc) {
                        Image(systemName: "checkmark")
                    }
                    if let icon = acc.icon {
                        IconView(icon: icon, font: .title3)
                    }
                    Text(acc.name)
                }
            }
        }
    }
}

//#Preview {
//    CurrencyView(item: <#Transactionable#>)
//}
