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
    private var currencies: [Currency]?
    
    @ObservationIgnored
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    

    
//    func saveCurrencies() throws -> [Currency] {
//        let curs = try modelContext.fetch(FetchDescriptor<Currency>())
//        if !curs.isEmpty {
//            return curs
//        }
//
//        try loadCurrenciesFromBundle()
//            .forEach{ modelContext.insert($0) }
//
//        try modelContext.save()
//        
//        return try modelContext.fetch(FetchDescriptor<Currency>())
//    }
    
    func getCurrencies() throws -> [Currency] {
        if let currencies = self.currencies {
            return currencies
        } else {
            guard let jsonUrl = Bundle.main.url(forResource: "Currencies", withExtension: "json") else {
                throw CurrencyError.jsonFileIsMissing
            }
            let data = try Data(contentsOf: jsonUrl)
            let dict = try JSONDecoder().decode([String: String].self, from: data)
            
            let currencies =  dict.compactMap { (key: String, value: String) in
                if !key.isEmpty && !value.isEmpty {
                    return Currency(code: key, name: value, icon: "")
                } else {
                    return nil
                }
            }
            self.currencies = currencies
            return currencies
        }
        
    }
}
