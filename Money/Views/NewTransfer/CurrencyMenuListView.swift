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
        
    var body: some View {
        ForEach(data) { acc in
            Button {
                withAnimation {
                    selectedItem = acc
                }
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
