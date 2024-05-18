//
//  ExpensesView.swift
//  Money
//
//  Created by Artem on 09.03.2024.
//

import SwiftUI
import SwiftData

private enum HistoryType: String, CaseIterable {
    case all = "Show all"
    case income = "Income"
    case betweenAccounts = "Between accounts"
    case spending = "Spendings"
}

private struct TransactionsByDate {
    let date: Date
    let transactions: [Transaction]
}

struct HistoryView: View {
    @Query(sort: \Transaction.date) var transactions: [Transaction]
    @State private var selectedTransType = HistoryType.all
    @State private var filteredData = [Transaction]()
    @State private var groupedData = [TransactionsByDate]()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Picker(selection: $selectedTransType) {
                    ForEach(HistoryType.allCases, id: \.self) { type in
                        Text(type.rawValue)
                        
                    }
                } label: {}
            }
            List {
                ForEach(groupedData, id: \.date) { group in
                    Section {
                        ForEach(group.transactions) { transaction in
                            if transaction.isIncome {
                                IncomeView(transaction: transaction)
                            } else if transaction.destination.isAccount {
                                TransferView(transaction: transaction)
                            } else {
                                SpengingView(transaction: transaction)
                            }
                        }
                        .padding(.vertical, 5)
                    } header: {
                        Text(group.date.historyDateString)
                            .font(.title2)
                    }
                }
            }
        }
        .navigationTitle("History")
        .onChange(of: transactions, initial: true) {
            groupedData = group(transactions: filterTransactions())
            
        }
        .onChange(of: selectedTransType) {
            groupedData = group(transactions: filterTransactions())
        }
    }
    
    private func group(transactions: [Transaction]) -> [TransactionsByDate] {
        return Dictionary(grouping: transactions) { $0.date.omittedTime }
            .map { TransactionsByDate(date: $0.key, transactions: $0.value) }
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
    HistoryView()
}

extension Date {
    var omittedTime: Date {
        let cal = Calendar.current
        return cal.date(from: cal.dateComponents([.year, .month, .day], from: self))!
    }
    
    var historyDateString: String {
        let form = DateFormatter()
        form.dateFormat = "dd.MM.YYYY"
        return form.string(from: self)
    }
}
