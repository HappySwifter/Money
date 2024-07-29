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

private enum PaginationState: Equatable {
    case idle
    case isLoading
    case error(error: Error)
    
    static func == (lhs: PaginationState, rhs: PaginationState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.isLoading, .isLoading):
            return true
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}

@MainActor
struct HistoryView: View {
    @Environment(\.dataHandlerWithMainContext) private var dataHandler
    @Environment(ExpensesService.self) private var expensesService
    private let fetchChunkSize = 20
    
    @State private var selectedTransType = HistoryType.all
    @State private var transactions = [MyTransaction]()
    @State private var groupedData = [TransactionsByDate]()
    
    @State private var paginationState = PaginationState.idle
    @State private var allDataCount = 0
    
    private var isMoreDataAvailable: Bool {
        assert(transactions.count <= allDataCount)
        return transactions.count < allDataCount
    }
    
    var body: some View {
        VStack() {
            HStack {
                Spacer()
                Picker(selection: $selectedTransType) {
                    ForEach(HistoryType.allCases, id: \.self) { type in
                        Text(type.rawValue)
                    }
                } label: {}
            }
            if groupedData.isEmpty {
                Spacer()
                Text("No data available")
                    .font(.title)
                Spacer()
            } else {
                List {
                    ForEach(groupedData, id: \.date) { group in
                        Section {
                            ForEach(group.transactions) { transaction in
                                switch transaction.type {
                                case .income:
                                    if let amount = transaction.destinationAmount {
                                        IncomeView(amount: amount,
                                                   account: transaction.destination)
                                    }
                                case .betweenAccounts:
                                    if let source = transaction.source {
                                        TransferView(transaction: transaction,
                                                     source: source,
                                                     destination: transaction.destination)
                                    }
                                case .spending:
                                    if let source = transaction.source {
                                        SpengingView(transaction: transaction,
                                                     source: source,
                                                     destination: transaction.destination)
                                    }
                                case .unknown:
                                    Color.white
                                }
                            }
                            .onDelete(perform: { indexSet in
                                if let index = indexSet.first {
                                    deleteTransaction(at: index, date: group.date)
                                }
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
            NavigationLink(destination: AllCategoriesView()) {
                Text("Manage categories")
                    .padding()
            }
        }
        .dynamicTypeSize(.xSmall ... .accessibility1)
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
        .toolbar {
            EditButton()
        }
    }
    
    var lastRowView: some View {
        ZStack(alignment: .center) {
            switch paginationState {
            case .idle:
                Color.clear
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
            paginationState = .error(error: error)
        }
    }
    
    private func fetchTransactions(type: HistoryType, offset: Int) async {
        guard isMoreDataAvailable, paginationState == .idle else {
            return
        }
        paginationState = .isLoading
        print("fetchTransactions", offset)
        do {
            if let dataHandler = await dataHandler() {
                let predicate = getPredicateFor(type: type)
                let sortBy = [SortDescriptor(\MyTransaction.date, order: .reverse)]
                let newChunk = try await dataHandler.getTransactions(
                    with: predicate,
                    sortBy: sortBy,
                    offset: offset,
                    fetchLimit: fetchChunkSize)
                transactions.append(contentsOf: newChunk)
                groupedData = group(transactions: transactions)
                paginationState = .idle
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
            return #Predicate<MyTransaction> { $0.destination.isAccount && !$0.isIncome }
        case .spending:
            return #Predicate<MyTransaction> { !$0.destination.isAccount }
        }
    }
    
    private func deleteTransaction(at index: Int, date: Date) {
        Task { @MainActor in
            do {
                guard let trans = groupedData.first(where: { $0.date == date }) else {
                    return
                }
                let model = trans.transactions[index]
                try await dataHandler()?.undo(transaction: model)
                await fetchCount(type: selectedTransType)
                transactions.removeAll(where: { $0.id == model.id })
                groupedData = group(transactions: transactions)
                try await expensesService.calculateSpentAndAccountsTotal()
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
