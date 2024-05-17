//
//  ExpensesView.swift
//  Money
//
//  Created by Artem on 09.03.2024.
//

import SwiftUI
import SwiftData

private enum TransactionType: String, CaseIterable {
    case all = "Show all"
    case income = "Income"
    case betweenAccounts = "Between accounts"
    case spending = "Spendings"
}

private struct TransactionsByDate {
    let date: Date
    let transactions: [Transaction]
}

struct TransactionsView: View {
    @Query(sort: \Transaction.date) var transactions: [Transaction]
    @State private var selectedTransType = TransactionType.all
    @State private var filteredData = [Transaction]()
    @State private var groupedData = [TransactionsByDate]()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Picker(selection: $selectedTransType) {
                    ForEach(TransactionType.allCases, id: \.self) { type in
                        Text(type.rawValue)
                            
                    }
                } label: {
                    
                }
            }
            List {

                ForEach(groupedData, id: \.date) { date in
                    Section {
                        ForEach(date.transactions) { transaction in
                            if transaction.isIncome {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(transaction.destination.icon)
                                            .font(.largeTitle)
                                        Text(transaction.destination.name)
                                            .font(.title3)
                                        Spacer()
                                        Group {
                                            Text(transaction.sign)
                                            Text(transaction.destinationAmount?.getString() ?? "")
                                            Text(transaction.destination.currency?.symbol ?? "")
                                        }
                                        .foregroundStyle(Color.green)
                                    }
                                    Text("New income")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
                            } else {
                                if transaction.destination.isAccount {
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
                                } else {
                                    HStack {
                                        Text(transaction.destination.icon)
                                            .font(.largeTitle)
                                        Text(transaction.destination.name)
                                            .font(.title3)
                                        Spacer()
                                        Text(transaction.source.name)
                                        Text("\(transaction.sign) \(transaction.sourceAmount.getString()) \(transaction.source.currency?.symbol ?? "")")
                                            .font(.title3)
                                    }
                                    
                                }
                                
                            }
                        }
                        .padding(.vertical, 5)
                    } header: {
                        Text(date.date.historyDateString)
                            .font(.title2)
                    } footer: {
                        
                    }

                }
            }
        }
        .navigationTitle("History")
        .onChange(of: transactions, initial: true) {
            let filtered = filterTransactions()
            groupedData = group(transactions: filtered)
        }
        .onChange(of: selectedTransType) {
            let filtered = filterTransactions()
            groupedData = group(transactions: filtered)
        }
    }
    
    private func group(transactions: [Transaction]) -> [TransactionsByDate] {
        let grouped = Dictionary(grouping: transactions) { $0.date.historyDate }
        return grouped
            .map{ TransactionsByDate(date: $0.key, transactions: $0.value) }
            .sorted { $0.date > $1.date }
    }
    
    private func filterTransactions() -> [Transaction] {
        return transactions.filter { trans in
            switch selectedTransType {
            case .all:
                return true
            case .income:
                return trans.isIncome
            case .betweenAccounts:
                return trans.destination.isAccount && !trans.isIncome
            case .spending:
                return !trans.destination.isAccount
            }
        }
    }
}

#Preview {
    TransactionsView()
}
