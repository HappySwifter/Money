//
//  MoneyApp.swift
//  Money
//
//  Created by Artem on 27.02.2024.
//

import SwiftUI
import SwiftData

@main
struct MoneyApp: App {
    let currencyApi: CurrenciesApi

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            CircleItem.self,
            Currency.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        currencyApi = CurrenciesApi(modelContext: sharedModelContainer.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            Dashboard()
        }
        .modelContainer(sharedModelContainer)
        .environment(currencyApi)
    }
}
