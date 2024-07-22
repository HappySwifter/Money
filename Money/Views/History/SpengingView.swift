//
//  SpengingView.swift
//  Money
//
//  Created by Artem on 18.05.2024.
//

import SwiftUI
import DataProvider

struct SpengingView: View {
    @State var transaction: MyTransaction
    
    var body: some View {
        HStack {
            if let icon = transaction.destination?.icon {
                IconView(icon: icon, font: .largeTitle)
            }
            Text(transaction.destination?.name ?? "deleted")
                .font(.title3)
            Spacer()
            Text(transaction.source?.name ?? "deleted")
            Text("- \(transaction.sourceAmount.getString()) \(transaction.source?.currency?.symbol ?? "")")
                .font(.title3)
        }
    }
}
