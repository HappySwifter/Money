//
//  MoneyTests.swift
//  MoneyTests
//
//  Created by Artem on 02.08.2024.
//

import Testing
import DataProvider
import Foundation

@testable import Money // testable helps to import targets whose access is internal

// #require


struct MoneyTests {
    let prov = DataProvider.shared
    
//    func requireExample() throws {
//        throw URLError(.unknown)
//    }
    
    @Test func example() async throws {
        
        
//        let method = try #require(requireExample())
        
        let cont = await prov.dataHandlerWithMainContextCreator()()
        
        let account = Account(orderIndex: 0, name: "Hello", color: .blue, isAccount: true, amount: 1000)
        await cont.new(account: account)
        
        let count = try await cont.getAccountsCount()

        #expect(count == 1)
    }

}
