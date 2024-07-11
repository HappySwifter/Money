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
                if let icon = transaction.source?.icon {
                    IconView(icon: icon, font: .title2)
                }
                Text(transaction.source?.name ?? "deleted")
                Spacer()
                Text(transaction.sourceAmount.getString())
                Text(transaction.source?.currency?.symbol ?? "")
            }
            Spacer()
            HStack {
                if let icon = transaction.destination?.icon {
                    IconView(icon: icon, font: .title2)
                }
                Text(transaction.destination?.name ?? "deleted")
                Spacer()
                if transaction.source?.currency != transaction.destination?.currency {
                    Text(transaction.destinationAmount?.getString() ?? "")
                    Text(transaction.destination?.currency?.symbol ?? "")
                }
            }
            Text("Between accounts")
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.top, 3)
            
        }
    }
}
