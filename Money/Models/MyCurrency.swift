////
////  Currency.swift
////  Money
////
////  Created by Artem on 04.03.2024.
////
//
import Foundation
import DataProvider
//
//@Model
//final class MyCurrency {
//    let code: String
//    let name: String
//    let symbol: String
//    
//    init(code: String, name: String, symbol: String?) {
//        self.code = code
//        self.name = name
//        self.symbol = symbol ?? String(code.prefix(2))
//    }
//}

extension MyCurrency {
    static func loadFromJson() throws -> [String: String] {
        guard let url = Bundle.main.url(forResource: "Currencies", withExtension: "json") else {
            throw CurrencyError.jsonFileIsMissing
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([String: String].self, from: data)
    }
}
