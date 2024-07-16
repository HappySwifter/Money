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

private enum PaginationState {
    case isLoading
    case error(error: Error)
}

struct HistoryView: View {
    private let fetchChunkSize = 15
    
    @Environment(\.modelContext) private var modelContext
    @Environment(ExpensesService.self) private var expensesService
    
    @State private var selectedTransType = HistoryType.all
    @State private var transactions = [Transaction]()
    @State private var groupedData = [TransactionsByDate]()
        
    @State private var paginationState = PaginationState.isLoading
    @State private var allDataCount = 0
    
    private var isMoreDataAvailable: Bool { transactions.count < allDataCount }
    
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
                if isMoreDataAvailable {
                    lastRowView
                }
            }
        }
        .navigationTitle("History")
        .onAppear {
            transactions.removeAll()
            fetchCount(type: selectedTransType)
        }
        .onChange(of: selectedTransType) {
            transactions.removeAll()
            fetchCount(type: selectedTransType)
        }
    }
        
    var lastRowView: some View {
        ZStack(alignment: .center) {
            switch paginationState {
            case .isLoading:
                ProgressView()
            case .error(let error):
                HistoryErrorView(error: error)
            }
        }
        .frame(height: 50)
        .onAppear {
            fetchTransactions(type: selectedTransType,
                              offset: transactions.count)
        }
    }
    
    private func fetchCount(type: HistoryType) {
        do {
            var fetchDescriptor = FetchDescriptor<Transaction>()
            fetchDescriptor.predicate = getPredicateFor(type: type)
            self.allDataCount = try modelContext.fetchCount(fetchDescriptor)
        } catch {
            print(error)
        }
    }

    private func fetchTransactions(type: HistoryType, offset: Int) {
        do {
            paginationState = .isLoading
            var fetchDescriptor = FetchDescriptor<Transaction>()
            fetchDescriptor.predicate = getPredicateFor(type: type)
            fetchDescriptor.sortBy = [SortDescriptor(\.date, order: .reverse)]
            fetchDescriptor.fetchLimit = fetchChunkSize
            fetchDescriptor.fetchOffset = offset
            let newChunk = try modelContext.fetch(fetchDescriptor)
            transactions.append(contentsOf: newChunk)
            groupedData = group(transactions: transactions)
        } catch {
            paginationState = .error(error: error)
        }
    }
    
    private func getPredicateFor(type: HistoryType) -> Predicate<Transaction>? {
        switch type {
        case .all:
            return nil
        case .income:
            return #Predicate<Transaction> { $0.isIncome }
        case .betweenAccounts:
            return #Predicate<Transaction> { ($0.destination?.isAccount ?? false) && !$0.isIncome }
        case .spending:
            return #Predicate<Transaction> { !($0.destination?.isAccount ?? false) }
        }
    }
    
    private func deleteTransaction(at offsets: IndexSet, date: Date) {
        if let trans = groupedData.first(where: { $0.date == date }) {
            for i in offsets {
                let model = trans.transactions[i]
                transactions.removeAll(where: { $0.id == model.id })
                modelContext.delete(model)
            }
            groupedData = group(transactions: transactions)
            try? expensesService.calculateSpent()
        }
    }
    
//    private func group(transactions: [Transaction]) -> [[Transaction]] {
//        let cal = Calendar.current
//        return  transactions
//            .sorted { $0.date > $1.date }
//            .chunked { cal.isDate($0.date, equalTo: $1.date, toGranularity: .month) }
//            .map { Array($0) }
//    }
    
    private func group(transactions: [Transaction]) -> [TransactionsByDate] {
        return Dictionary(grouping: transactions) { $0.date.omittedTime }
            .map { TransactionsByDate(date: $0.key, transactions: $0.value) }
            .sorted { $0.date > $1.date }
    }
}

//#Preview {
//    HistoryView()
//}

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
