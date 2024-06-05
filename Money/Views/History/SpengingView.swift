//
//  SpengingView.swift
//  Money
//
//  Created by Artem on 18.05.2024.
//

import SwiftUI

struct SpengingView: View {
    @State var transaction: Transaction
    
    var body: some View {
        HStack {
            Text(transaction.destination?.icon ?? "")
                .font(.largeTitle)
            Text(transaction.destination?.name ?? "deleted")
                .font(.title3)
            Spacer()
            Text(transaction.source?.name ?? "deleted")
            Text("- \(transaction.sourceAmount.getString()) \(transaction.source?.currency?.symbol ?? "")")
                .font(.title3)
        }
    }
}
