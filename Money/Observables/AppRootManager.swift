//
//  AppRootManager.swift
//  Money
//
//  Created by Artem on 11.07.2024.
//

import Foundation
import DataProvider
import OSLog

@MainActor
@Observable final class AppRootManager {
    private let logger = Logger(subsystem: "Money", category: "AppRootManager")
    var currentRoot: AppRoots = .loadingView(title: "")
    let dataHandler: DataHandler
    
    init(dataHandler: DataHandler) {
        self.dataHandler = dataHandler
        updateRoot()
    }
    
    func updateRoot() {
        Task { @MainActor in
            do {
                let accountsCount = try await dataHandler.getAccountsCount()
                
                if accountsCount == 0 {
                    currentRoot = .addDataHelper
                } else if accountsCount == 0  {
                    currentRoot = .addAccount
                } else {
                    currentRoot = .dashboard
                }
            } catch {
                logger.error("\(error.localizedDescription)")
                currentRoot = .addDataHelper
            }
        }
    }
    
    enum AppRoots {
        case dashboard
        case addDataHelper
        case loadingView(title: String)
        case addAccount
    }
}
