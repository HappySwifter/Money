////
////  Currency.swift
////  Money
////
////  Created by Artem on 04.03.2024.
////
//
import Foundation
import DataProvider

extension AccountCurrency {
    static func loadFromJson() throws -> [AccountCurrency] {
        guard let url = Bundle.main.url(forResource: "Currencies", withExtension: "json") else {
            throw CurrencyError.jsonFileIsMissing
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([AccountCurrency].self, from: data)
    }
}
