//
//  SettingsView.swift
//  Money
//
//  Created by Artem on 11.07.2024.
//

import SwiftUI
import SwiftData



struct SettingsView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(SettingsService.self) private var settings
    @Environment(AppRootManager.self) private var rootManager
    @Environment(Preferences.self) private var preferences
    
    @State private var accountNameIsInside = true
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Account") {
                    Toggle(isOn: $accountNameIsInside, label: {
                        Text("Name is inside")
                    })
                }
                Section("App data") {
                    Button("Delete data") {
                        deleteAllData()
                    }
                    .foregroundStyle(.red)
                    Button("Populate with mock random data") {
                        populateWithMockRandomData()
                    }
                    .foregroundStyle(.red)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem {
                    Button("Save") {
                        save()
                        dismiss()
                    }
                }
            }
            .onAppear {
                accountNameIsInside = settings.appSettings.isAccountNameInside
            }
        }
    }
        
    private func save() {
        let appSettings = AppSettings(isAccountNameInside: accountNameIsInside)
        settings.save(settings: appSettings)
    }
    
    private func deleteAllData() {
        do {
            try context.delete(model: Account.self)
            try context.delete(model: MyCurrency.self)
            try context.delete(model: Transaction.self)
            
            rootManager.updateRoot()
        } catch {
            print(error)
        }
    }
    
    private func populateWithMockRandomData() {
        context.autosaveEnabled = false

        
        let currenciesDesc = FetchDescriptor<MyCurrency>()
        let currencies = (try? context.fetch(currenciesDesc)) ?? []
        
        let accDesc = FetchDescriptor<Account>()
        var accountsCount = (try? context.fetchCount(accDesc)) ?? 0
        
        let accountNames = ["Bank1", "Cash1", "X", "My New Account", "CryptoCurrency", "HelloCredit", "One more", "Hi dude", "Tired to find new names", "Hello1", "Hello2", "Hello3", "Hello4", "Hello5", "Hello6", "Hello7"]
        
        let categoryNames = ["Food", "Cafe", "Gifts", "Relatives", "Car", "Scootie service", "Fuel", "Home", "Bills", "Clothes", "My darling wife", "Fruits", "Home rent", "Relaxation", ""]
        
        let nonClearColors = SwiftColor.allCases.filter({ $0 != .clear })

        var accounts = [Account]()
        for name in accountNames {
            let amount = Double((100...9999999).randomElement()!)
            let icon = Icon(name: IconType.all.getIcons().randomElement() ?? "",
                            color: nonClearColors.randomElement()!,
                            isMulticolor: true)
            let acc = Account(orderIndex: accountsCount,
                              name: name,
                              color: nonClearColors.randomElement()!,
                              isAccount: true,
                              amount: amount)
            acc.icon = icon
            
            if name == accountNames.first {
                acc.currency = preferences.getUserCurrency()
            } else {
                acc.currency = currencies.randomElement()
            }
            
            accountsCount += 1
            accounts.append(acc)
            
        }
        print("Acc finished")
        
        var categories = [Account]()
        for name in categoryNames {
            let icon = Icon(name: IconType.all.getIcons().randomElement() ?? "",
                            color: nonClearColors.randomElement()!,
                            isMulticolor: true)
            let category = Account(orderIndex: accountsCount,
                              name: name,
                              color: SwiftColor.allCases.randomElement()!,
                              isAccount: false,
                              amount: 0)
            category.icon = icon
            context.insert(category)
            accountsCount += 1
            categories.append(category)
        }
        print("Cat finished")
        
        // Incomes
        var incomes = [Transaction]()
        for _ in (0..<50) {
            let amount = Double((10...999).randomElement()!)
            let ramdomSeconds = Double((0...31560100).randomElement()!)
            let tran = Money.Transaction(date: Date(timeIntervalSinceNow: -ramdomSeconds),
                                         isIncome: true,
                                         sourceAmount: amount,
                                         source: nil,
                                         destinationAmount: amount,
                                         destination: accounts.randomElement())
            incomes.append(tran)
        }
        print("Incomes finished")
        
        // Transfers
        var transfers = [Transaction]()
        for _ in (0..<50) {
            let ramdomSeconds = Double((0...31560100).randomElement()!)
            let sourseAcc = accounts.randomElement()!
            let destAcc = accounts.filter { $0 != sourseAcc }.randomElement()
            let sourceaAmount = Double((1...Int(sourseAcc.amount / 10)).randomElement()!)
            let destAmount = Double((Int(sourceaAmount / 1.5)...Int(sourceaAmount)).randomElement()!)
            
            guard sourseAcc.credit(amount: sourceaAmount) else {
                print("Cant transfer. Not enough of funds")
                continue
            }
            destAcc?.deposit(amount: destAmount)
            
            let tran = Money.Transaction(date: Date(timeIntervalSinceNow: -ramdomSeconds),
                                         isIncome: false,
                                         sourceAmount: sourceaAmount,
                                         source: sourseAcc,
                                         destinationAmount: destAmount,
                                         destination: destAcc)
            transfers.append(tran)
        }
        print("Transfers finished")
            
        //Spendings
        var spendinds = [Transaction]()
        for _ in (0..<10000) {
            let sourseAcc = accounts.randomElement()!
            let sourceaAmount = Double((1...100).randomElement()!)
            guard sourseAcc.credit(amount: sourceaAmount) else {
                print("Cant spend. Not enough of funds")
                continue
            }
            
            let ramdomSeconds = Double((0...31560100).randomElement()!)
            let tran = Money.Transaction(date: Date(timeIntervalSinceNow: -ramdomSeconds),
                                         isIncome: false,
                                         sourceAmount: sourceaAmount,
                                         source: sourseAcc,
                                         destinationAmount: nil,
                                         destination: categories.randomElement())
            spendinds.append(tran)
            
        }
        print("spendinds finished")
        
        
        
        do {
            try context.transaction {
                for obj in accounts {
//                    if obj.name == accountNames.first {
//                        obj.currency = preferences.getUserCurrency()
//                    } else {
//                        obj.currency = currencies.randomElement()
//                    }
//                    context.insert(obj)
                }
                for obj in categories {
//                    context.insert(obj)
                }
                for obj in incomes {
                    context.insert(obj)
                }
                for obj in transfers {
                    context.insert(obj)
                }
                for obj in spendinds {
                    context.insert(obj)
                }
                print("Done instering")
                try context.save()
                
                print(">>>>> autosaveEnabled = true")
                context.autosaveEnabled = true
                dismiss()
            }
        } catch {
            print(error)
        }
        
    }
}

#Preview {
    let pref = Preferences(userDefaults: .standard, modelContext: previewContainer.mainContext)

    return SettingsView()
        .environment(pref)
        .modelContainer(previewContainer)
}
