//
//  EnterAmountView.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import SwiftUI
import SwiftData
import DataProvider
import OSLog


@MainActor
struct TransferMoneyView: View {
    private let logger = Logger(subsystem: "Money", category: "TransferMoneyView")
    private let useSystemKeyboard = true

    @Environment(\.dataHandlerWithMainContext) private var dataHandler
    @Environment(ExpensesService.self) private var expensesService

    @Query(filter: Account.accountPredicate(),
           sort: \Account.orderIndex)
    private var accounts: [Account]
    
    @Query(
        filter: Account.categoryPredicate(),
        sort: \Account.orderIndex)
    private var categories: [Account]
        
    @State private var focusedField = FieldFocusType.source
    @State private var targetDate = Date()
    @State private var sourceAmount = ""
    @State private var destinationAmount = ""
    @State private var comment = ""
    
    @State var source: Account
    @State var destination: Account
    @Binding var isSheetPresented: Bool
    
    private var transactionType: TransactionViewType {
        TransactionViewType(source: source, destination: destination)
    }
    
    private var doneButtonIsDisabled: Bool {
        let sourceAmountDouble = sourceAmount.toDouble() ?? 0
        if sourceAmountDouble == 0 || !source.canCredit(amount: sourceAmountDouble) {
            return true
        }
        switch transactionType {
        case .accountToCategory, .accountToAccountSameCurrency:
            return false
        case .accountToAccountDiffCurrency:
            return destinationAmount.toDouble() ?? 0 == 0
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 15) {
                    HStack {
                        Menu {
                            Text("Accounts")
                            CurrencyMenuListView(selectedItem: $source, data: accounts)
                        } label: {
                            AccountView(item: $source,
                                        selected: .constant(true),
                                        presentingType: .constant(.none))
                        }
                        .buttonStyle(.plain)
                        .environment(\.menuOrder, .fixed)
                        
                        Spacer()
                        Image(systemName: "arrowshape.forward")
                        Spacer()
                        Menu {
                            if destination.isAccount {
                                Text("Accounts")
                                CurrencyMenuListView(selectedItem: $destination, data: accounts)
                                Divider()
                                Text("Categories")
                                CurrencyMenuListView(selectedItem: $destination, data: categories)
                            } else {
                                Text("Categories")
                                CurrencyMenuListView(selectedItem: $destination, data: categories)
                                Divider()
                                Text("Accounts")
                                CurrencyMenuListView(selectedItem: $destination, data: accounts)
                            }
                        } label: {
                            if destination.isAccount {
                                AccountView(item: $destination,
                                            selected: .constant(true),
                                            presentingType: .constant(.none))
                            } else {
                                CategoryView(item: $destination)
                                    .padding()
                            }
                        }
                        .buttonStyle(.plain)
                        .environment(\.menuOrder, .fixed)
                    }
                    HStack {
                        EnterAmountView(
                            symbol: source.currency?.symbol ?? "",
                            isFocused: focusedField == .source,
                            value: $sourceAmount,
                            useTextField: useSystemKeyboard)
                        .onTapGesture {
                            focusedField = .source
                        }
                        
                        if transactionType == .accountToAccountDiffCurrency {
                            Spacer()
                            EnterAmountView(
                                symbol: destination.currency?.symbol ?? "",
                                isFocused: focusedField == .destination,
                                value: $destinationAmount,
                                useTextField: useSystemKeyboard)
                            .onTapGesture {
                                focusedField = .destination
                            }
                        }
                    }
                    HStack {
                        DatePicker("", selection: $targetDate, displayedComponents: .date)
                        Spacer()
                    }
                }
                .padding()
                Spacer()
                
                
                HStack(alignment: .bottom) {
                    TextField("", text: $comment, prompt: Text("Comment"), axis: .vertical)
                    Button(" Done ") {
                        makeTransfer()
                    }
                    .disabled(doneButtonIsDisabled)
                    .buttonStyle(DoneButtonStyle())
                    .dynamicTypeSize(.xLarge ... .xLarge)
                }
                .padding()
                
                if !useSystemKeyboard {
                    CalculatorView(viewModel: CalculatorViewModel(showCalculator: false),
                                   resultString: focusedField == .source ? $sourceAmount : $destinationAmount)
                }
//                Spacer()
            }
            .onChange(of: source) { oldValue, _ in
                withAnimation {
                    swapItemsIfNeeded(oldValue: oldValue, changedItemType: .source)
                }
                
            }
            .onChange(of: destination) { oldValue, _ in
                withAnimation {
                    swapItemsIfNeeded(oldValue: oldValue, changedItemType: .destination)
                }
                
            }
            .navigationTitle(destination.isAccount ? "New transaction" : "New expense")
            .navigationBarTitleDisplayMode(.inline)
            .dynamicTypeSize(.xLarge ... .xLarge)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        isSheetPresented.toggle()
                    }
                }
            }
        }
    }
    
    private func normalizedString(rate: Double) -> String {
        let sourceSymbol = source.currency?.symbol ?? ""
        let destinationSymbol = destination.currency?.symbol ?? ""
        if rate > 1 {
            return rate.getString() + " " + destinationSymbol
        } else {
            return (1 / rate).getString() + " " + sourceSymbol
        }
    }
    
    private func makeTransfer() {
        Task { @MainActor in
            let sourceAmount = sourceAmount.toDouble()!
            var destAmount: Double?
            guard source.credit(amount: sourceAmount) else {
                return
            }
           
            switch transactionType {
            case .accountToAccountDiffCurrency:
                let destinationAmount = destinationAmount.toDouble()!
                destination.deposit(amount: destinationAmount)
                destAmount = destinationAmount
                
            case .accountToAccountSameCurrency:
                destination.deposit(amount: sourceAmount)
                destAmount = sourceAmount
                
            case .accountToCategory:
                break
            }

            let transaction = MyTransaction(date: targetDate,
                                            isIncome: false,
                                            sourceAmount: sourceAmount,
                                            source: source,
                                            destinationAmount: destAmount,
                                            destination: destination, 
                                            comment: comment.isEmpty ? nil : comment)
            
            await dataHandler()?.new(transaction: transaction)
            isSheetPresented.toggle()
            await calculateSpent()
        }
    }
    
    private func calculateSpent() async {
        do {
            try await expensesService.calculateSpentAndAccountsTotal()
        } catch let error as NetworkError {
            logger.error("\(error.description)")
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
    
    private func swapItemsIfNeeded(
        oldValue: Account,
        changedItemType: FieldFocusType)
    {
        if source.id == destination.id {
            if oldValue.isAccount {
                // swaping
                switch changedItemType {
                case .source: destination = oldValue
                case .destination: source = oldValue
                }
            } else {
                // restoring old state
                switch changedItemType {
                case .source: source = oldValue
                case .destination: destination = oldValue
                }
            }
        }
        if !destination.isAccount {
            focusedField = .source
            destinationAmount = "0"
//            exchangeRate = nil
        }
    }
    
//    private func updateRate() {
//        guard let sourceCode = source.currency?.code,
//              let destCode = destination.currency?.code else {
//            return
//        }
//        Task {
//            exchangeRate = try await loadRates(
//                sourceCode: sourceCode,
//                destinationCode: destCode) ?? 0
//            //                updateDestinationAmount(from: sourceAmount)
//        }
//    }
    
    //    private func updateSourceAmount(from destination: String) {
    //        if sourceAmount == "0" {
    //            if let exchangeRate,
    //               exchangeRate > 0,
    //               let destination = destination.toDouble()
    //            {
    //                sourceAmount = (destination / exchangeRate).getString()
    //            } else {
    //                sourceAmount = "0"
    //            }
    //        } else {
    //            if let sour = sourceAmount.toDouble(), let dest = destinationAmount.toDouble(), dest > 0 {
    //                exchangeRate = sour / dest
    //            }
    //        }
    //    }
    //
    //    private func updateDestinationAmount(from source: String) {
    //        guard destination.isAccount else { return }
    //
    //        if destinationAmount == "0" {
    //            if let exchangeRate,
    //               exchangeRate > 0,
    //               let source = source.toDouble()
    //            {
    //                destinationAmount = (source * exchangeRate).getString()
    //            } else {
    //                destinationAmount = "0"
    //            }
    //        } else {
    //            if let sour = sourceAmount.toDouble(), let dest = destinationAmount.toDouble(), sour > 0 {
    //                exchangeRate = dest / sour
    //            }
    //        }
    //    }
    
//    private func loadRates(sourceCode: String, destinationCode: String) async throws -> Double? {
//        let rates = try await currenciesApi.getExchangeRateFor(currencyCode: sourceCode, date: Date())
//        return rates.value(for: destinationCode)
//    }
}

//private extension Binding {
//    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
//        Binding(
//            get: { self.wrappedValue },
//            set: { newValue in
//                self.wrappedValue = newValue
//                handler(newValue)
//            }
//        )
//    }
//}

//#Preview {
//    
//    let preferences = Preferences(userDefaults: UserDefaults.standard)
//    let expensesService = ExpensesService(preferences: preferences)
//    
//    
//    var desc = FetchDescriptor<Account>()
//    desc.predicate = Account.accountPredicate()
//    let accounts = try! previewContainer.mainContext.fetch(desc)
//    
//    desc.predicate = Account.categoryPredicate()
//    let categories = try! previewContainer.mainContext.fetch(desc)
//    
//    return TransferMoneyView(source: accounts[0],
//                             destination: categories[1],
//                             isSheetPresented: .constant(true))
//        .modelContainer(previewContainer)
//        .environment(expensesService)
//}

extension TransferMoneyView {
    enum FieldFocusType: Hashable {
        case source
        case destination
        
        var title: String {
            switch self {
            case .source:
                return "From"
            case .destination:
                return "To"
            }
        }
    }
}
