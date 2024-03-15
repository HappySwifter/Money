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
            let container = sharedModelContainer

            let descriptor = FetchDescriptor<MyCurrency>()
            let existingCur = try container.mainContext.fetchCount(descriptor)
            guard existingCur == 0 else { return }

            
            guard let jsonUrl = Bundle.main.url(forResource: "Currencies", withExtension: "json") else {
                throw CurrencyError.jsonFileIsMissing
            }
            let data = try Data(contentsOf: jsonUrl)
            let dict = try JSONDecoder().decode([String: String].self, from: data)
            let symbols = try CurrencySymbol.getAll()
            
            let currencies =  dict.compactMap { (key: String, value: String) in
                if !key.isEmpty && !value.isEmpty {
                    return MyCurrency(code: key,
                                      name: value,
                                      symbol: symbols.findWith(code: key)?.symbol ?? "")
                } else {
                    return nil
                }
            }

            for currenciy in currencies {
                container.mainContext.insert(currenciy)
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
