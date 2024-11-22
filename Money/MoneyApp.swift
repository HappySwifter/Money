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
    private let currenciesManager: CurrenciesManager
    
    @MainActor private let dataHandler: DataHandler

    

    
    init() {
        do {
            #if DEBUG
            try Tips.resetDatastore()
            #endif
            try Tips.configure()
        } catch {
            logger.error("Error initializing TipKit: \(error)")
        }
        
        appRootManager = AppRootManager()
        currenciesManager = CurrenciesManager()
        preferences = Preferences(currenciesManager: currenciesManager)
        expensesService = ExpensesService(preferences: preferences)
        
        dataHandler = DataHandler(modelContainer: dataProvider.sharedModelContainer, mainActor: true)
        
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
        
    private func checkCloudKitSyncStatus() {
        Task {
            let dataHandler = DataHandler(modelContainer: DataProvider.shared.sharedModelContainer)
            let accountsCount = try await dataHandler.getAccountsCount()
            
            if accountsCount == 0 {
                CloudKitManager.getCloudKitSyncStatus { status in
                    switch status {
                    case .still:
                        break
                    case .importing:
                        appRootManager.currentRoot = .loadingView(title: "Loading data from iCloud...")
                    case .finishImporting:
                        calculateTotal()
                        appRootManager.updateRoot()
                        CloudKitManager.stopObservingChanges()
                    }
                }
            } else {
                calculateTotal()
            }
        }
    }

    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appRootManager.currentRoot {
                case .addDataHelper:
                    BaseCurrencyView()
                case .addAccount:
                    NewAccountView(isSheetPresented: .constant(true),
                                   isClosable: false,
                                   completion: { [weak appRootManager] in
                        appRootManager?.updateRoot()
                    })
                case .dashboard:
                    Dashboard()
                    
//                    ExchangeRateView(newCurrency: AccountCurrency(code: "rub", name: "Russian Rubble", symbol: "R"))
                    
                    
//                    NewAccountView(isSheetPresented: .constant(true),
//                                   isClosable: false,
//                                   completion: { [weak appRootManager] in
//                        appRootManager?.updateRoot()
//                    })
                case .loadingView(let title):
                    LoadingView(title: title)
                }
            }
            .dynamicTypeSize(.xLarge ... .xLarge)
        }
        .modelContainer(dataProvider.sharedModelContainer)
        .environment(\.dataHandlerWithMainContext, dataHandler)
        .environment(preferences)
        .environment(expensesService)
        .environment(currenciesManager)
        .environment(appRootManager)
    }
}
