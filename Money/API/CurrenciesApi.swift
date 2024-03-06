//
//  CurrenciesApi.swift
//  Money
//
//  Created by Artem on 04.03.2024.
//

import Foundation
import SwiftData

@Observable
class CurrenciesApi {
    
    @ObservationIgnored
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    enum CurrencyError: Error {
        case jsonFileIsMissing
    }
    
    func getCurrencies() throws -> [Currency] {
        let curs = try modelContext.fetch(FetchDescriptor<Currency>())
        if !curs.isEmpty {
            return curs
        }

        guard let jsonUrl = Bundle.main.url(forResource: "Currencies", withExtension: "json") else {
            throw CurrencyError.jsonFileIsMissing
        }
        let data = try Data(contentsOf: jsonUrl)
        let dict = try JSONDecoder().decode([String: String].self, from: data)
        
        
        dict.forEach { (key: String, value: String) in
            if !key.isEmpty && !value.isEmpty {
                let cur = Currency(code: key, name: value, icon: "")
                modelContext.insert(cur)
            }
        }
        try modelContext.save()
        
        return try modelContext.fetch(FetchDescriptor<Currency>())
    }
}
