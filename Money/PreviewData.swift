//
//  PreviewData.swift
//  Money
//
//  Created by Artem on 13.07.2024.
//

import Foundation
import SwiftData
//
//@MainActor
//struct PreviewData {
//    static let instanse = PreviewData()
//    let modelContainer: ModelContainer
//    
//    let account1: Account
//    let account2: Account
//    
//    let category1: Account
//    let category2: Account
//    
//    init() {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try! ModelContainer(for: MyCurrency.self, Account.self, Transaction.self, configurations: config)
//        modelContainer = container
//        
//        let acc = Account(orderIndex: 0, name: "Bank", color: .green, isAccount: true, amount: 0)
//        let acc2 = Account(orderIndex: 0, name: "Cash", color: .yellow, isAccount: true, amount: 1000)
//        acc.currency = MyCurrency(code: "RUB", name: "Ruble", symbol: "R")
//        acc2.currency = MyCurrency(code: "RUB", name: "Ruble", symbol: "R")
//        container.mainContext.insert(acc)
//        container.mainContext.insert(acc2)
//
//        account1 = acc
//        account2 = acc2
//        
//        let cat = Account(orderIndex: 0, name: "Food", color: .green, isAccount: false, amount: 0)
//        let cat2 = Account(orderIndex: 0, name: "Clothes", color: .yellow, isAccount: false, amount: 0)
//        container.mainContext.insert(acc)
//        container.mainContext.insert(acc2)
//        
//        
//        category1 = cat
//        category2 = cat2
//    }
//}

//@MainActor
//class DataController {
//    static let previewContainer: ModelContainer = {
//        do {
//            let config = ModelConfiguration(isStoredInMemoryOnly: true)
//            let container = try ModelContainer(for: MyCurrency.self, Account.self, Transaction.self, configurations: config)
//
//            for i in 1...9 {
//                let user = Account(orderIndex: 0, name: "Bank \(i)", color: .green, isAccount: true, amount: 0)
//                container.mainContext.insert(user)
//            }
//
//            return container
//        } catch {
//            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
//        }
//    }()
//}
