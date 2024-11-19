//
//  TransferView.swift
//  Money
//
//  Created by Artem on 18.05.2024.
//

import SwiftUI
import DataProvider

struct TransferView: View {
    let transaction: MyTransaction
    let source: Account
    let destination: Account
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let icon = transaction.source?.icon {
                    IconView(icon: icon, font: .title2)
                }
                Text(source.name)
                    .foregroundStyle(source.nameColor)
                Spacer()
                Text(transaction.sourceAmount.getString())
                Text(source.getCurrency()?.symbol ?? "")
            }
            Spacer()
            HStack {
                IconView(icon: destination.icon, font: .title2)
                Text(destination.name)
                    .foregroundStyle(destination.nameColor)
                Spacer()
                if source.getCurrency() != destination.getCurrency() {
                    Text(transaction.destinationAmount?.getString() ?? "")
                    Text(destination.getCurrency()?.symbol ?? "")
                }
            }
            Text("Between accounts")
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.top, 3)
            
        }
    }
}
