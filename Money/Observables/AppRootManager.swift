//
//  AppRootManager.swift
//  Money
//
//  Created by Artem on 11.07.2024.
//

import Foundation
import DataProvider

@MainActor
@Observable final class AppRootManager {
    var currentRoot: appRoots = .dashboard
    private let dataHandler = DataHandler(modelContainer: DataProvider.shared.sharedModelContainer, mainActor: true)
    
    init() {
        updateRoot()
    }
    
    func updateRoot() {
        Task { @MainActor in
            do {
                let accountsCount = try await dataHandler.getAccountsCount()
                let categoriesCount = try await dataHandler.getCategoriesCount()
                
                if accountsCount == 0 &&
                    categoriesCount == 0 {
                    currentRoot = .addDataHelper
                } else if accountsCount == 0  {
                    currentRoot = .addAccount
                } else if categoriesCount == 0 {
                    currentRoot = .addCategory
                } else {
                    currentRoot = .dashboard
                }
            } catch {
                print(error)
                currentRoot = .addDataHelper
            }
        }
    }
    
    enum appRoots {
        case dashboard
        case addDataHelper
        case addAccount
        case addCategory
    }
}
