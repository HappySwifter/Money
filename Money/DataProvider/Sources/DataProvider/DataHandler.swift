//
//  DataHandler.swift
//
//
//  Created by Yang Xu on 2024/3/16.
//

import Foundation
import SwiftData

@ModelActor
public actor DataHandler {
    
    @MainActor
    public init(modelContainer: ModelContainer, mainActor _: Bool) {
        let modelContext = modelContainer.mainContext
        modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
        self.modelContainer = modelContainer
    }
    
    @discardableResult
    public func new(account: Account) -> PersistentIdentifier {
        modelContext.insert(account)
        return account.persistentModelID
    }
    
    public func getAccounts(with predicate: Predicate<Account>, fetchLimit: Int? = nil) throws -> [Account] {
        var desc = FetchDescriptor<Account>()
        desc.predicate = predicate
        if let fetchLimit {
            desc.fetchLimit = fetchLimit
        } else {
            desc.sortBy = [SortDescriptor(\.orderIndex)]
        }
        return try modelContext.fetch(desc)
    }

    
    public func getAccounts() throws -> [Account] {
        var desc = FetchDescriptor<Account>()
        desc.predicate = Account.accountPredicate()
        desc.sortBy = [SortDescriptor(\.orderIndex)]
        return try modelContext.fetch(desc)
    }
    
    public func getCategories() throws -> [Account] {
        var desc = FetchDescriptor<Account>()
        desc.predicate = Account.categoryPredicate()
        desc.sortBy = [SortDescriptor(\.orderIndex)]
        return try modelContext.fetch(desc)
    }
    
    public func getAccountsCount() throws -> Int {
        var desc = FetchDescriptor<Account>()
        desc.predicate = Account.accountPredicate()
        return try modelContext.fetchCount(desc)
    }
    
    public func getCategoriesCount() throws -> Int {
        var desc = FetchDescriptor<Account>()
        desc.predicate = Account.categoryPredicate()
        return try modelContext.fetchCount(desc)
    }
    
    public func hide(account: Account) {
        //guard let item = self[id, as: Account.self] else { return }
        account.hid = true
    }
    

}

//MARK: Transactions
extension DataHandler {
    public func new(transaction: MyTransaction) {
        modelContext.insert(transaction)
    }
    
    public func getTransactionsCount(with predicate: Predicate<MyTransaction>?) throws -> Int {
        var desc = FetchDescriptor<MyTransaction>()
        if let predicate {
            desc.predicate = predicate
        }
        return try modelContext.fetchCount(desc)
    }
    
    public func getTransactions(with predicate: Predicate<MyTransaction>?,
                                sortBy: [SortDescriptor<MyTransaction>]?,
                                propertiesToFetch: [PartialKeyPath<MyTransaction>]? = nil,
                                offset: Int?,
                                fetchLimit: Int?) throws -> [MyTransaction] {
        var desc = FetchDescriptor<MyTransaction>()
        if let predicate {
            desc.predicate = predicate
        }
        if let sortBy {
            desc.sortBy = sortBy
        }
        if let offset {
            desc.fetchOffset = offset
        }
        if let fetchLimit {
            desc.fetchLimit = fetchLimit
        }
        if let propertiesToFetch {
            desc.propertiesToFetch = propertiesToFetch
        }
        return try modelContext.fetch(desc)
    }
    
    public func getTransaction(for period: TransactionPeriodType? = nil) throws -> [MyTransaction] {
        var desc = FetchDescriptor<MyTransaction>()
        if let period {
            desc.predicate = MyTransaction.predicateFor(period: period, calendar: Calendar.current)
        }
        return try modelContext.fetch(desc)
    }
    
    public func undo(transaction: MyTransaction) throws {
        switch transaction.type {
        case .income:
            let destination = transaction.destination
            destination.credit(amount: transaction.sourceAmount)
        case .betweenAccounts:
            guard let source = transaction.source else {
                throw DataProviderError.transactionSourceMissing
            }
            let destination = transaction.destination
            guard let destinationAmount = transaction.destinationAmount else {
                throw DataProviderError.transactionDestinationAmountMissing
            }
            source.deposit(amount: transaction.sourceAmount)
            destination.credit(amount: destinationAmount)
        case .spending:
            guard let source = transaction.source else {
                throw DataProviderError.transactionSourceMissing
            }
            source.deposit(amount: transaction.sourceAmount)
        case .unknown:
            throw DataProviderError.unknownTransactionType
        }
        modelContext.delete(transaction)
    }
}

//MARK: Currency
extension DataHandler {
    
    @discardableResult
    public func newCurrency(name: String, code: String, symbol: String?) -> MyCurrency {
        let currency = MyCurrency(code: code, name: name, symbol: symbol)
        modelContext.insert(currency)
        return currency
    }
    
    public func getCurrencies() throws -> [MyCurrency] {
        return try modelContext.fetch(FetchDescriptor<MyCurrency>())
    }
    
    public func getCurrenciesCount() throws -> Int {
        return try modelContext.fetchCount(FetchDescriptor<MyCurrency>())
    }
        
    public func getCurrencyWith(code: String) throws -> MyCurrency? {
        var desc = FetchDescriptor<MyCurrency>()
        let pred = #Predicate<MyCurrency> { $0.code == code }
        desc.fetchLimit = 1
        desc.predicate = pred
        return try modelContext.fetch(desc).first
    }
}

//MARK: Test data
extension DataHandler {
    public func addTestData(userCurrency: MyCurrency) throws {
        let accountsCount = try getAccountsCount()
        let catCount = try getCategoriesCount()
        
        let accountCash = Account(orderIndex: accountsCount,
                                  name: "Cash",
                                  color: SwiftColor.lavender.rawValue,
                                  isAccount: true,
                                  amount: 1000,
                                  iconName: "banknote",
                                  iconColor: SwiftColor.green.rawValue)
        
        let accountBank = Account(orderIndex: accountsCount + 1,
                                  name: "Bank",
                                  color: SwiftColor.mintCream.rawValue,
                                  isAccount: true,
                                  amount: 10000,
                                  iconName: "creditcard",
                                  iconColor: SwiftColor.blue.rawValue)
        
        let categoryFood = Account(orderIndex: catCount,
                                   name: "Food",
                                   color: SwiftColor.lightSand.rawValue,
                                   isAccount: false,
                                   amount: 0,
                                   iconName: "basket",
                                   iconColor: SwiftColor.indigo.rawValue)
        
        let categoryClothes = Account(orderIndex: catCount + 1,
                                      name: "Clothes",
                                      color: SwiftColor.powderPink.rawValue,
                                      isAccount: false,
                                      amount: 0,
                                      iconName: "tshirt",
                                      iconColor: SwiftColor.orange.rawValue)
        
        
        accountCash.currency = userCurrency
        accountBank.currency = userCurrency
        modelContext.insert(categoryFood)
        modelContext.insert(categoryClothes)
    }
}

extension DataHandler {
    public func clearDB() throws {
        try modelContext.delete(model: Account.self)
        try modelContext.delete(model: MyTransaction.self)
    }
}
