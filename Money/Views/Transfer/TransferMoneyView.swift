//
//  EnterAmountView.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import SwiftUI
import SwiftData
import DataProvider

@MainActor
struct TransferMoneyView: View {
    @Environment(\.dataHandlerWithMainContext) private var dataHandler
    @Environment(ExpensesService.self) private var expensesService

    @Query(filter: #Predicate<Account> { $0.isAccount },
           sort: \Account.orderIndex)
    private var accounts: [Account]
    
    @Query(
        filter: #Predicate<Account> { !$0.isAccount },
        sort: \Account.orderIndex)
    private var categories: [Account]
    
    @State var source: Account
    @State var destination: Account
    @Binding var isSheetPresented: Bool
    
    @State private var exchangeRate: Double?
    @State private var sourceAmount = "0"
    @State private var destinationAmount = "0"
    
    enum ItemType: Hashable {
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
    @State private var focusedField = ItemType.source
    
    var doneButtonIsDisabled: Bool {
        if sourceAmount.toDouble() == 0 ||
            destination.isAccount &&
            source.currency?.code != destination.currency?.code &&
            (destinationAmount.toDouble() ?? 0) == 0
        {
            return true
        }
        else {
            return false
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 15) {
                    HStack {
                        Menu {
                            Text("Accounts")
                            CurrencyMenuListView(selectedItem: $source, data: accounts) {
                                swapItemsIfNeededAndUpdateRate(oldValue: $0, changedItemType: ItemType.source)
                            }
                        } label: {
                            TransactionAccountView(
                                viewType: .source,
                                item: source
                            )
                        }
                        .buttonStyle(.plain)
                        .environment(\.menuOrder, .fixed)
                        
                        Menu {
                            if destination.isAccount {
                                Text("Accounts")
                                CurrencyMenuListView(selectedItem: $destination, data: accounts) {
                                    swapItemsIfNeededAndUpdateRate(oldValue: $0, changedItemType: .destination)
                                }
                                Divider()
                                Text("Categories")
                                CurrencyMenuListView(selectedItem: $destination, data: categories) {
                                    swapItemsIfNeededAndUpdateRate(oldValue: $0, changedItemType: .destination)
                                }
                            } else {
                                Text("Categories")
                                CurrencyMenuListView(selectedItem: $destination, data: categories) {
                                    swapItemsIfNeededAndUpdateRate(oldValue: $0, changedItemType: .destination)
                                }
                                Divider()
                                Text("Accounts")
                                CurrencyMenuListView(selectedItem: $destination, data: accounts) {
                                    swapItemsIfNeededAndUpdateRate(oldValue: $0, changedItemType: .destination)
                                }
                            }
                        } label: {
                            TransactionAccountView(
                                viewType: .destination,
                                item: destination
                            )
                        }
                        .buttonStyle(.plain)
                        .environment(\.menuOrder, .fixed)
                    }
                    HStack {
                        EnterAmountView(
                            symbol: source.currency?.symbol ?? "",
                            isFocused: focusedField == .source,
                            value: $sourceAmount)
                        .onTapGesture {
                            focusedField = .source
                        }
                        
                        if destination.isAccount,
                           source.currency?.code != destination.currency?.code {
                            Spacer()
                            EnterAmountView(
                                symbol: destination.currency?.symbol ?? "",
                                isFocused: focusedField == .destination,
                                value: $destinationAmount)
                            .onTapGesture {
                                focusedField = .destination
                            }
                        }
                    }
                    
                    if let exchangeRate, (source.currency?.code != destination.currency?.code) {
                        Text("Exchange rate: \(normalizedString(rate: exchangeRate))")
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                    }
                }
                .padding()
                Spacer()
                
                
                HStack {
                    Spacer()
                    Button(" Done ") {
                        makeTransfer()
                    }
                    .disabled(doneButtonIsDisabled)
                    .buttonStyle(DoneButtonStyle())
                }
                .padding(.horizontal)
                
                //                CalculatorView(viewModel: CalculatorViewModel(showCalculator: false),
                //                               resultString: focusedField == .source ? $sourceAmount.onChange(updateDestinationAmount) : $destinationAmount.onChange(updateSourceAmount))
                
                CalculatorView(viewModel: CalculatorViewModel(showCalculator: false),
                               resultString: focusedField == .source ? $sourceAmount : $destinationAmount)
            }
            .navigationTitle(destination.isAccount ? "New transaction" : "New expense")
            .navigationBarTitleDisplayMode(.inline)
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
            guard let sourceAmount = sourceAmount.toDouble(), sourceAmount > 0 else {
                print("Enter source amount")
                return
            }
            guard source.credit(amount: sourceAmount) else {
                print("Not enough of money")
                return
            }
            
            var destAmount: Double?
            if destination.isAccount {
                if source.currency?.code == destination.currency?.code {
                    destination.deposit(amount: sourceAmount)
                    destAmount = sourceAmount
                } else {
                    guard let destinationAmount = destinationAmount.toDouble(), destinationAmount > 0 else {
                        assert(false)
                        return
                    }
                    destination.deposit(amount: destinationAmount)
                    destAmount = destinationAmount
                }
            }
            
            let transaction = MyTransaction(isIncome: false,
                                          sourceAmount: sourceAmount,
                                          source: source,
                                          destinationAmount: destAmount,
                                          destination: destination)
            print(transaction.id)
            await dataHandler()?.new(transaction: transaction)
            await calculateSpent()
            isSheetPresented.toggle()
 
        }
    }
    
    private func calculateSpent() async {
        do {
            try await expensesService.calculateSpent()
        } catch let error as NetworkError {
            print(error.description)
        } catch {
            print(error)
        }
    }
    
    private func swapItemsIfNeededAndUpdateRate(
        oldValue: Account,
        changedItemType: ItemType)
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
        if destination.isAccount {
//            updateRate()
        } else {
            focusedField = .source
            destinationAmount = "0"
            exchangeRate = nil
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

private extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}

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
