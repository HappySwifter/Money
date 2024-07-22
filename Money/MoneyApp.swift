//
//  MoneyApp.swift
//  Money
//
//  Created by Artem on 27.02.2024.
//

import SwiftUI
import OSLog
import DataProvider

@main
struct MoneyApp: App {
    @State private var appRootManager: AppRootManager
    private let logger = Logger(subsystem: "Money", category: "MoneyApp")
    private let dataProvider = DataProvider.shared
    private let preferences: Preferences
    private let expensesService: ExpensesService
    
    init() {
        appRootManager = AppRootManager()
        preferences = Preferences(userDefaults: UserDefaults.standard)
        expensesService = ExpensesService(preferences: preferences)
               
        Task {
            do {
                let dataHandler = DataHandler(modelContainer: DataProvider.shared.sharedModelContainer)
                let count = try await dataHandler.getCurrenciesCount()
                guard count == 0 else { return }
                
                let currenciesFromJson = try MyCurrency.loadFromJson()
                let symbols = try CurrencySymbol.loadFromJson()
                
                for (code, name) in currenciesFromJson where !code.isEmpty && !name.isEmpty {
                    let symbol = symbols.findWith(code: code)?.symbol
                    try await dataHandler.newCurrency(name: name, code: code, symbol: symbol)
                }
            } catch {
                print("Failed to pre-seed database.")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appRootManager.currentRoot {
                case .addDataHelper:
                    AddDataHelperView()
                case .addAccount:
                    NewAccountView(isSheetPresented: .constant(true),
                                   isClosable: false,
                                   completion: appRootManager.updateRoot)
                case .addCategory:
                    NewCategoryView(isSheetPresented: .constant(true), 
                                    isClosable: false,
                                    completion: appRootManager.updateRoot)
                case .dashboard:
                    Dashboard()
                }
            }
        }
        .modelContainer(dataProvider.sharedModelContainer)
        .environment(\.dataHandler, dataProvider.dataHandlerCreator())
        .environment(\.dataHandlerWithMainContext, dataProvider.dataHandlerWithMainContextCreator())
        .environment(preferences)
        .environment(expensesService)
        .environment(appRootManager)
    }
}
