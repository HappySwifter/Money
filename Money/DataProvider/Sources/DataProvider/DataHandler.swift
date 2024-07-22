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
    public func new(account: Account) throws -> PersistentIdentifier {
        modelContext.insert(account)
        try modelContext.save()
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
    

//
//    public func updateItem(id: PersistentIdentifier, timestamp: Date) throws {
//        guard let item = self[id, as: Item.self] else { return }
//        item.timestamp = timestamp
//        try modelContext.save()
//    }
//    
    public func deleteAccount(_ account: Account) throws {
//        guard let item = self[id, as: Account.self] else { return }
        modelContext.delete(account)
        try modelContext.save()
    }
    

}

//MARK: Transactions
extension DataHandler {
    public func new(transaction: MyTransaction) throws {
        modelContext.insert(transaction)
        try modelContext.save()
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
        return try modelContext.fetch(desc)
    }
    
    public func getTransaction(for period: TransactionPeriodType? = nil) throws -> [MyTransaction] {
        var desc = FetchDescriptor<MyTransaction>()
        if let period {
            desc.predicate = MyTransaction.predicateFor(period: period, calendar: Calendar.current)
        }
        return try modelContext.fetch(desc)
    }
    
    public func delete(transation: MyTransaction) throws {
        modelContext.delete(transation)
        try modelContext.save()
    }
}

//MARK: Currency
extension DataHandler {
    
    @discardableResult
    public func newCurrency(name: String, code: String, symbol: String?) throws -> MyCurrency {
        let currency = MyCurrency(code: code, name: name, symbol: symbol)
        modelContext.insert(currency)
        try modelContext.save()
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
                                  color: .blue,
                                  isAccount: true,
                                  amount: 1000)
        
        let accountBank = Account(orderIndex: accountsCount + 1,
                                  name: "Bank",
                                  color: .blue,
                                  isAccount: true,
                                  amount: 10000)
        
        let categoryFood = Account(orderIndex: catCount,
                                   name: "Food",
                                   color: .clear,
                                   isAccount: false,
                                   amount: 0)
        
        let categoryClothes = Account(orderIndex: catCount + 1,
                                      name: "Clothes",
                                      color: .clear,
                                      isAccount: false,
                                      amount: 0)
        
        
        accountCash.currency = userCurrency
        accountCash.icon = Icon(name: "banknote", color: .green, isMulticolor: false)
        
        accountBank.currency = userCurrency
        accountBank.icon = Icon(name: "creditcard", color: .blue, isMulticolor: false)
        
        categoryFood.icon = Icon(name: "basket", color: .indigo, isMulticolor: false)
        categoryClothes.icon = Icon(name: "tshirt", color: .orange, isMulticolor: false)
        modelContext.insert(categoryFood)
        modelContext.insert(categoryClothes)
    }
}

extension DataHandler {
    public func clearDB() throws {
        try modelContext.delete(model: Account.self)
        try modelContext.delete(model: MyCurrency.self)
        try modelContext.delete(model: MyTransaction.self)
    }
}
