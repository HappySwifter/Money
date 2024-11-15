//
//  TransactionAccountView.swift
//  Money
//
//  Created by Artem on 09.03.2024.
//

import SwiftUI
import DataProvider

struct TransactionAccountView: View {
    let viewType: TransferMoneyView.FieldFocusType
    let item: Account
        
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(viewType.title)
                .font(.footnote)
            HStack(spacing: 5) {
                Text("\(item.name)")
                    .lineLimit(1)
                    .font(item.isAccount ? .title3 : .title2)
                if let icon = item.icon {
                    IconView(icon: icon, font: .title3)
                }
            }
            .opacity(item.isAccount ? 0.7 : 1)
            
            HStack(spacing: 3) {
                Text(item.amount.getString())
                Text(item.currency?.symbol ?? "")
                Spacer()
            }
            .font(.title3)
            .opacity(item.isAccount ? 1 : 0.01)
        }
        .frame(height: 120)
        .padding()
        .background(SwiftColor(rawValue: item.color)?.value)
        .cornerRadiusWithBorder(radius: 10, borderColor: item.isAccount ? .clear : item.icon!.color.value)
        .dynamicTypeSize(.xSmall ... .xxLarge)
    }
}
