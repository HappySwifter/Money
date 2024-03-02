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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            CircleItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
//            ContentView3()
            Dashboard(viewModel: DashboardViewModel())
        }
        .modelContainer(sharedModelContainer)
    }
}
