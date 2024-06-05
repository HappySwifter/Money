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

struct TransactionsByDate {
    let date: Date
    let transactions: [Transaction]
}

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(ExpensesService.self) private var expensesService
    
    @State private var transactions = [Transaction]()
    @State private var selectedTransType = HistoryType.all
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
            List(groupedData, id: \.date) { group in
                Section {
                    ForEach(group.transactions) { transaction in
                        if transaction.isIncome {
                            IncomeView(transaction: transaction)
                        } else if (transaction.destination?.isAccount ?? false) {
                            TransferView(transaction: transaction)
                        } else {
                            SpengingView(transaction: transaction)
                        }
                    }
                    .onDelete(perform: { indexSet in
                        deleteTransaction(at: indexSet, date: group.date)
                    })
                    .padding(.vertical, 5)
                } header: {
                    Text(group.date.historyDateString)
                        .font(.title3)
                }
            }
        }
        .navigationTitle("History")
        .onAppear {
            fetchTransactions()
        }
        .onChange(of: selectedTransType) {
            groupedData = group(transactions: filter(transactions: self.transactions))
        }
    }
    
    private func fetchTransactions() {
        do {
            let fetchDescriptor = FetchDescriptor<Transaction>(
                sortBy: [SortDescriptor(\.date, order: .reverse)]
            )
            self.transactions = try modelContext.fetch(fetchDescriptor)
            groupedData = group(transactions: filter(transactions: self.transactions))
        } catch {
            print(error)
        }
    }
    
    private func deleteTransaction(at offsets: IndexSet, date: Date) {
        if let trans = groupedData.first(where: { $0.date == date }) {
            for i in offsets {
                modelContext.delete(trans.transactions[i])
            }
            fetchTransactions()
            try? expensesService.calculateSpent()
        }
    }
    
    private func group(transactions: [Transaction]) -> [TransactionsByDate] {
        return Dictionary(grouping: transactions) { $0.date.omittedTime }
            .map { TransactionsByDate(date: $0.key, transactions: $0.value) }
            .sorted { $0.date > $1.date }
    }
    
    private func filter(transactions: [Transaction]) -> [Transaction] {
        return transactions.filter { trans in
            switch selectedTransType {
            case .all:
                return true
            case .income:
                return trans.isIncome
            case .betweenAccounts:
                return (trans.destination?.isAccount ?? false) && !trans.isIncome
            case .spending:
                return !(trans.destination?.isAccount ?? false)
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
        form.dateFormat = "dd MMM YYYY"
        return form.string(from: self)
    }
}
