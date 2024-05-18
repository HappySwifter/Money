//
//  TransferView.swift
//  Money
//
//  Created by Artem on 18.05.2024.
//

import SwiftUI

struct TransferView: View {
    @State var transaction: Transaction
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(transaction.source.icon)
                Text(transaction.source.name)
                Spacer()
                Text(transaction.sourceAmount.getString())
                Text(transaction.source.currency?.symbol ?? "")
            }
            Spacer()
            HStack {
                Text(transaction.destination.icon)
                Text(transaction.destination.name)
                Spacer()
                if transaction.source.currency != transaction.destination.currency {
                    Text(transaction.destinationAmount?.getString() ?? "")
                    Text(transaction.destination.currency?.symbol ?? "")
                }
            }
            Text("Between accounts")
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.top, 3)
            
        }
    }
}
