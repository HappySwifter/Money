//
//  MoneyApp.swift
//  Money
//
//  Created by Artem on 27.02.2024.
//

import SwiftUI
import OSLog
import DataProvider
import TipKit

@main
struct MoneyApp: App {
    @State private var appRootManager: AppRootManager
    private let logger = Logger(subsystem: "Money", category: "MoneyApp")
    private let dataProvider = DataProvider.shared
    private let preferences: Preferences
    private let expensesService: ExpensesService
    
    init() {
        try? Tips.configure()
        
        appRootManager = AppRootManager()
        preferences = Preferences()
        expensesService = ExpensesService(preferences: preferences)
        
        checkCloudKitSyncStatus()
    }
    
    private func calculateTotal() {
        Task { [expensesService, logger] in
            do {
                try await expensesService.calculateSpentAndAccountsTotal()
            } catch let error as NetworkError {
                logger.error("\(error.description)")
            } catch {
                logger.error("\(error.localizedDescription)")
            }
        }
    }
    
    private func populateCurrencies() {
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
    
    private func checkCloudKitSyncStatus() {
        Task {
            let dataHandler = DataHandler(modelContainer: DataProvider.shared.sharedModelContainer)
            let accountsCount = try await dataHandler.getAccountsCount()
            let categoriesCount = try await dataHandler.getCategoriesCount()
            
            if accountsCount == 0 || categoriesCount == 0 {
                CloudKitManager.getCloudKitSyncStatus { status in
                    switch status {
                    case .still:
                        break
                    case .importing:
                        appRootManager.currentRoot = .loadingView(title: "Loading data from iCloud...")
                    case .finishImporting:
                        calculateTotal()
                        populateCurrencies()
                        appRootManager.updateRoot()
                        CloudKitManager.stopObservingChanges()
                    }
                }
            } else {
                populateCurrencies()
                calculateTotal()
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
                case .loadingView(let title):
                    LoadingView(title: title)
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
