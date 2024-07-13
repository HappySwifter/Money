//
//  TransactionAccountView.swift
//  Money
//
//  Created by Artem on 09.03.2024.
//

import SwiftUI

struct TransactionAccountView: View {
    
    let viewType: TransferMoneyView.ItemType
    let item: Account
        
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(viewType.title)
                .font(.footnote)
            HStack(spacing: 3) {
                Text("\(item.name)")
                    .lineLimit(1)
                    .font(item.isAccount ? .title3 : .title2)
                if let icon = item.icon {
                    IconView(icon: icon, font: item.isAccount ? .title3 : .largeTitle)
                }
            }
            .opacity(item.isAccount ? 0.7 : 1)
            
            if item.isAccount {
                HStack(spacing: 3) {
                    Text(item.amount.getString())
                    Text(item.currency?.symbol ?? "")
                    Spacer()
                }
                .font(.title3)
            }
        }
        .padding()
        .frame(minHeight: 100, maxHeight: 120)
        .background(SwiftColor(rawValue: item.color)?.value.opacity(0.3))
        .cornerRadiusWithBorder(radius: 10, borderColor: (SwiftColor(rawValue: item.color) == .clear) ? item.icon!.color.value : .clear)
    }
}