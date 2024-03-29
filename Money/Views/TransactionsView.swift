//
//  ExpensesView.swift
//  Money
//
//  Created by Artem on 09.03.2024.
//

import SwiftUI
import SwiftData

struct TransactionsView: View {
    @Query(sort: \Transaction.date) var transactions: [Transaction]

    var body: some View {
        List {
            ForEach(transactions) { transaction in
                VStack {
                    HStack {
                        Text(transaction.source.icon)
                        Text(transaction.source.name)
                        Text(transaction.source.currency?.symbol ?? "")
                        Spacer()
                        Text(transaction.sign)
                            .foregroundStyle(transaction.isIncome ? Color.green : Color.red)
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
    TransactionsView()
}
