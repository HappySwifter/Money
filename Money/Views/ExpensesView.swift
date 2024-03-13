//
//  ExpensesView.swift
//  Money
//
//  Created by Artem on 09.03.2024.
//

import SwiftUI
import SwiftData

struct ExpensesView: View {
    @Query(sort: \Transaction.date) var transactions: [Transaction]

    var body: some View {
        List {
            ForEach(transactions) { transaction in
                VStack {
                    HStack {
                        Text(transaction.source.icon)
                        Text(transaction.source.name)
                        Text(transaction.source.accountDetails?.currency?.icon ?? "")
                        Spacer()
                        Text("-")
                        Text(transaction.sourceAmount.getString())
                    }
                    Spacer()
                    HStack {
                        if transaction.destination.isAccount {
                            Text(transaction.destination.name)
                            Text("-")
                            Text(transaction.destinationAmount?.getString() ?? "")
                        }

                    }
                }
            }
        }
    }
}

#Preview {
    ExpensesView()
}
