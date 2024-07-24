//
//  ExpensesView.swift
//  Money
//
//  Created by Artem on 09.03.2024.
//

import SwiftUI
import DataProvider

private enum HistoryType: String, CaseIterable {
    case all = "Show all"
    case income = "Income"
    case betweenAccounts = "Between accounts"
    case spending = "Spendings"
}

private enum PaginationState {
    case isLoading
    case error(error: Error)
}

@MainActor
struct HistoryView: View {
    @Environment(\.dataHandlerWithMainContext) private var dataHandler
    @Environment(ExpensesService.self) private var expensesService
    private let fetchChunkSize = 20

    @State private var selectedTransType = HistoryType.all
    @State private var transactions = [MyTransaction]()
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
        .task {
            await fetchCount(type: selectedTransType)
        }
        .task(id: selectedTransType) {
            transactions.removeAll()
            groupedData.removeAll()
            await fetchCount(type: selectedTransType)
            await fetchTransactions(type: selectedTransType, offset: 0)
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
        .task {
            await fetchTransactions(type: selectedTransType,
                              offset: transactions.count)
        }
    }
    
    private func fetchCount(type: HistoryType) async {
        do {
            let predicate = getPredicateFor(type: type)
            if let dataHandler = await dataHandler() {
                self.allDataCount = try await dataHandler.getTransactionsCount(with: predicate)
            }
        } catch {
            print(error)
        }
    }

    private func fetchTransactions(type: HistoryType, offset: Int) async {
        print("fetchTransactions", offset)
        do {
            paginationState = .isLoading
//            fetchDescriptor.propertiesToFetch =
            if let dataHandler = await dataHandler() {
                let predicate = getPredicateFor(type: type)
                let sortBy = [SortDescriptor(\MyTransaction.date, order: .reverse)]
                let newChunk = try await dataHandler.getTransactions(with: predicate,
                                               sortBy: sortBy,
                                               offset: offset,
                                               fetchLimit: fetchChunkSize)
                transactions.append(contentsOf: newChunk)
                groupedData = group(transactions: transactions)
            }
        } catch {
            paginationState = .error(error: error)
        }
    }
    
    private func getPredicateFor(type: HistoryType) -> Predicate<MyTransaction>? {
        switch type {
        case .all:
            return nil
        case .income:
            return #Predicate<MyTransaction> { $0.isIncome }
        case .betweenAccounts:
            return #Predicate<MyTransaction> { ($0.destination?.isAccount ?? false) && !$0.isIncome }
        case .spending:
            return #Predicate<MyTransaction> { !($0.destination?.isAccount ?? false) }
        }
    }
    
    private func deleteTransaction(at offsets: IndexSet, date: Date) {
        Task { @MainActor in
            do {
                if let trans = groupedData.first(where: { $0.date == date }) {
                    for i in offsets {
                        let model = trans.transactions[i]
                        transactions.removeAll(where: { $0.id == model.id })
                        try await dataHandler()?.undo(transaction: model)
                    }
                    groupedData = group(transactions: transactions)
                    try await expensesService.calculateSpent()
                }
            } catch let error as DataProviderError {
                print("ERROR: ", error.rawValue)
                assert(false)
            } catch {
                print(error)
            }
        }
    }
    
//    private func group(transactions: [Transaction]) -> [[Transaction]] {
//        let cal = Calendar.current
//        return  transactions
//            .sorted { $0.date > $1.date }
//            .chunked { cal.isDate($0.date, equalTo: $1.date, toGranularity: .month) }
//            .map { Array($0) }
//    }
    
    private func group(transactions: [MyTransaction]) -> [TransactionsByDate] {
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
