//
//  CurrencySymbol.swift
//  Money
//
//  Created by Artem on 07.03.2024.
//

import Foundation

struct CurrencySymbol: Codable {
    let currency: String?
    let abbreviation: String
    let symbol: String?
    
    static func getAll() throws -> [CurrencySymbol] {
        guard let jsonUrl = Bundle.main.url(forResource: "CurrencySymbols", withExtension: "json") else {
            return []
        }
        let data = try Data(contentsOf: jsonUrl)
        return try JSONDecoder().decode([CurrencySymbol].self, from: data)
    }
}

extension [CurrencySymbol] {
    func findWith(code: String) -> CurrencySymbol? {
        return self.first(where: { $0.abbreviation.lowercased() == code.lowercased() })
    }
}
