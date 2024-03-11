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
            Account.self,
            SpendCategory.self,
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
        
        preferences = Preferences(userDefaults: UserDefaults.standard)
        
        currencyApi = CurrenciesApi(modelContext: sharedModelContainer.mainContext,
                                    preferences: preferences)
    }

    var body: some Scene {
        WindowGroup {
            Dashboard()
        }
        .modelContainer(sharedModelContainer)
        .environment(currencyApi)
        .environment(preferences)
    }
}
