//
//  IncomeView.swift
//  Money
//
//  Created by Artem on 18.05.2024.
//

import SwiftUI
import DataProvider

struct IncomeView: View {
    @State var transaction: MyTransaction
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let icon = transaction.destination?.icon {
                    IconView(icon: icon, font: .largeTitle)
                }
                Text(transaction.destination?.name ?? "deleted")
                    .font(.title3)
                Spacer()
                Group {
                    Text("+")
                    Text(transaction.destinationAmount?.getString() ?? "")
                    Text(transaction.destination?.currency?.symbol ?? "")
                }
                .foregroundStyle(Color.green)
            }
            Text("New income")
                .font(.caption)
                .foregroundStyle(.gray)
        }
    }
}
