//
//  AppRootManager.swift
//  Money
//
//  Created by Artem on 11.07.2024.
//

import Foundation
import SwiftData

@Observable final class AppRootManager {
    private let modelContext: ModelContext
    var currentRoot: appRoots = .dashboard
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        updateRoot()
    }
    
    func updateRoot() {
        var desc = FetchDescriptor<Account>()
        desc.predicate = Account.accountPredicate()
        let accountsCount = try? modelContext.fetchCount(desc)
        
        desc.predicate = Account.categoryPredicate()
        let categoriesCount = try? modelContext.fetchCount(desc)
        
        if accountsCount == 0 &&
            categoriesCount == 0 ||
            accountsCount == nil ||
            categoriesCount == nil {
            currentRoot = .addDataHelper
        } else if accountsCount == 0  {
            currentRoot = .addAccount
        } else if categoriesCount == 0 {
            currentRoot = .addCategory
        } else {
            currentRoot = .dashboard
        }
    }
    
    enum appRoots {
        case dashboard
        case addDataHelper
        case addAccount
        case addCategory
    }
}
