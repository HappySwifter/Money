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
        preferences = Preferences()
        expensesService = ExpensesService(preferences: preferences)
        
        Task { [expensesService, logger] in
            do {
                try await expensesService.calculateSpentAndAccountsTotal()
            } catch let error as NetworkError {
                logger.error("\(error.description)")
            } catch {
                logger.error("\(error.localizedDescription)")
            }
        }
        
        Task { [logger, preferences] in
            do {
                let dataHandler = DataHandler(modelContainer: DataProvider.shared.sharedModelContainer)
                guard !preferences.isCurrencyPopulated() else { return }
                
                let currenciesFromJson = try MyCurrency.loadFromJson()
                let symbols = try CurrencySymbol.loadFromJson()
                
                for (code, name) in currenciesFromJson where !code.isEmpty && !name.isEmpty {
                    let symbol = symbols.findWith(code: code)?.symbol
                    await dataHandler.newCurrency(name: name,
                                                  code: code,
                                                  symbol: symbol)
                }
                logger.info("Populated \(currenciesFromJson.count) currencies")
                preferences.setCurrencyPopulated()
            } catch {
                logger.error("\(error.localizedDescription)")
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
                                   completion: { [weak appRootManager] in
                        appRootManager?.updateRoot()
                    })
                case .addCategory:
                    NewCategoryView(isSheetPresented: .constant(true), 
                                    isClosable: false,
                                    completion: { [weak appRootManager] in
                        appRootManager?.updateRoot()
                    })
                case .dashboard:
                    Dashboard()
                }
            }
            .dynamicTypeSize(.xLarge ... .xLarge)
        }
        .modelContainer(dataProvider.sharedModelContainer)
        .environment(\.dataHandler, dataProvider.dataHandlerCreator())
        .environment(\.dataHandlerWithMainContext, dataProvider.dataHandlerWithMainContextCreator())
        .environment(preferences)
        .environment(expensesService)
        .environment(appRootManager)
    }
}
