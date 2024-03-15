//
//  MoneyApp.swift
//  Money
//
//  Created by Artem on 27.02.2024.
//

import SwiftUI
import SwiftData
import OSLog

@main
struct MoneyApp: App {
    let logger = Logger(subsystem: "Money", category: "MoneyApp")
    let currencyApi: CurrenciesApi
    let preferences: Preferences
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            MyCurrency.self,
            Account.self,
            Transaction.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        preferences = Preferences(userDefaults: UserDefaults.standard,
                                  modelContext: sharedModelContainer.mainContext)
        
        currencyApi = CurrenciesApi(modelContext: sharedModelContainer.mainContext,
                                    preferences: preferences)
        
        do {
            let context = sharedModelContainer.mainContext
            let descriptor = FetchDescriptor<MyCurrency>()
            let existingCur = try context.fetchCount(descriptor)
            guard existingCur == 0 else { return }

            guard let url = Bundle.main.url(forResource: "Currencies", withExtension: "json") else {
                throw CurrencyError.jsonFileIsMissing
            }
            let data = try Data(contentsOf: url)
            let dict = try JSONDecoder().decode([String: String].self, from: data)
            let symbols = try CurrencySymbol.getAll()
            
            for (code, name) in dict where !code.isEmpty && !name.isEmpty {
                let symbol = symbols.findWith(code: code)?.symbol
                let currency =  MyCurrency(code: code, name: name, symbol: symbol)
                context.insert(currency)
            }
        } catch {
            print("Failed to pre-seed database.")
        }
    }
        

    var body: some Scene {
        WindowGroup {
            Dashboard()
        }
        .modelContainer(sharedModelContainer)
        .environment(currencyApi)
        .environment(preferences)
//        .modelContainer(for: MyCurrency.self) { result in
//
//        }
    }
}
