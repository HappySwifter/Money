//
//  File.swift
//  
//
//  Created by Artem on 22.07.2024.
//

import Foundation
import SwiftData

extension DataHandler {
    public func populateWithMockData(userCurrency: AccountCurrency, currencies: [AccountCurrency], iconNames: [String]) throws {
        modelContext.autosaveEnabled = false
        
        assert(!currencies.isEmpty)
        var accountsCount = try getAccountsCount()
        var categoriesCount = try getCategoriesCount()
        
        let accountNames = ["Bank1", "Cash1", "X", "My New Account", "CryptoCurrency", "HelloCredit", "One more", "Hi dude", "Tired to find new names", "Hello1", "Hello2", "Hello3", "Hello4", "Hello5", "Hello6", "Hello7"]
        
        let categoryNames = ["Food", "Cafe", "Gifts", "Relatives", "Car", "Scootie service", "Fuel", "Home", "Bills", "Clothes", "My darling wife", "Fruits", "Home rent", "Relaxation", ""]
        
        let accountColors = SwiftColor.accountColors
        let nonClearColors = SwiftColor.categoryColors.filter({ $0 != .clear })

        var accounts = [Account]()
        for name in accountNames {
            let amount = Double((100...9999999).randomElement()!)

            let acc = Account(orderIndex: accountsCount,
                              name: name,
                              color: accountColors.randomElement()!.rawValue,
                              isAccount: true,
                              amount: amount,
                              iconName: iconNames.randomElement() ?? "",
                              iconColor: nonClearColors.randomElement()!.rawValue)

            if let cur = currencies.randomElement() {
                acc.set(currency: cur)
            }
            modelContext.insert(acc)
            accountsCount += 1
            accounts.append(acc)
            
        }
        print("Acc finished")
        
        var categories = [Account]()
        for name in categoryNames {
            let category = Account(orderIndex: categoriesCount,
                              name: name,
                                   color: SwiftColor.clear.rawValue,
                              isAccount: false,
                              amount: 0,
                                   iconName: iconNames.randomElement() ?? "",
                                   iconColor: nonClearColors.randomElement()!.rawValue)
            modelContext.insert(category)
            categoriesCount += 1
            categories.append(category)
        }
        print("Cat finished")
        
        // Incomes
        var incomes = [MyTransaction]()
        for _ in (0..<50) {
            let amount = Double((10...999).randomElement()!)
            let ramdomSeconds = Double((0...31560100).randomElement()!)
            let tran = MyTransaction(date: Date(timeIntervalSinceNow: -ramdomSeconds),
                                         isIncome: true,
                                         sourceAmount: amount,
                                         source: nil,
                                         destinationAmount: amount,
                                     destination: accounts.randomElement()!,
                                     comment: nil)
            incomes.append(tran)
        }
        print("Incomes finished")
        
        // Transfers
        var transfers = [MyTransaction]()
        for _ in (0..<50) {
            let ramdomSeconds = Double((0...31560100).randomElement()!)
            let sourseAcc = accounts.randomElement()!
            let destAcc = accounts.filter { $0 != sourseAcc }.randomElement()!
            let sourceaAmount = Double((1...Int(sourseAcc.amount / 10)).randomElement()!)
            let destAmount = Double((Int(sourceaAmount / 1.5)...Int(sourceaAmount)).randomElement()!)
            
            guard sourseAcc.credit(amount: sourceaAmount) else {
                print("Cant transfer. Not enough of funds")
                continue
            }
            destAcc.deposit(amount: destAmount)
            
            let tran = MyTransaction(date: Date(timeIntervalSinceNow: -ramdomSeconds),
                                         isIncome: false,
                                         sourceAmount: sourceaAmount,
                                         source: sourseAcc,
                                         destinationAmount: destAmount,
                                     destination: destAcc, 
                                     comment: nil)
            transfers.append(tran)
        }
        print("Transfers finished")
            
        //Spendings
        var spendinds = [MyTransaction]()
        for _ in (0..<10000) {
            let sourseAcc = accounts.randomElement()!
            let sourceaAmount = Double((1...100).randomElement()!)
            guard sourseAcc.credit(amount: sourceaAmount) else {
                print("Cant spend. Not enough of funds")
                continue
            }
            
            let ramdomSeconds = Double((0...31560100).randomElement()!)
            let tran = MyTransaction(date: Date(timeIntervalSinceNow: -ramdomSeconds),
                                         isIncome: false,
                                         sourceAmount: sourceaAmount,
                                         source: sourseAcc,
                                         destinationAmount: nil,
                                     destination: categories.randomElement()!,
                                     comment: nil)
            spendinds.append(tran)
            
        }
        print("spendinds finished")
        
        
        let myCurrency = MyCurrency(name: "Dollar", code: "USD", symbol: "USD", rateToBaseCurrency: 0, isBase: true)
        
        try modelContext.transaction {
            for obj in incomes {
                modelContext.insert(obj)
            }
            for obj in transfers {
                modelContext.insert(obj)
            }
            for obj in spendinds {
                modelContext.insert(obj)
            }
            
            modelContext.insert(myCurrency)

            print("Done instering")
            try modelContext.save()
            
            print(">>>>> autosaveEnabled = true")
            modelContext.autosaveEnabled = true
        }
        save()
    }
}
