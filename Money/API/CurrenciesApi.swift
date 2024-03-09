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
    

    enum ExchangeRateUrlType {
        case main
        case fallback
        
        func getUrl(for currencyCode: String) throws -> URL {
            let urlString: String
            switch self {
            case .main:
                urlString = "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies"
            case .fallback:
                urlString = "https://latest.currency-api.pages.dev/v1/currencies"
            }
            if let url = URL(string: urlString) {
                return url
                    .appending(path: "\(currencyCode)")
                    .appendingPathExtension("json")
            } else {
                throw URLError(.badURL)
            }
        }
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
    
    func getCurrencySymbol(for currencyCode: String) -> String? {
        guard let jsonUrl = Bundle.main.url(forResource: "CurrencySymbols", withExtension: "json") else {
            return nil
        }
        if let data = try? Data(contentsOf: jsonUrl), let symbols = try? JSONDecoder().decode([CurrencySymbol].self, from: data) {
            return symbols
                .first(where: { $0.abbreviation.lowercased() == currencyCode.lowercased() })?
                .symbol
        } else {
            return nil
        }
    }
    
    func getExchangeRateFor(currencyCode: String, urlType: ExchangeRateUrlType = .main) async throws -> ExchangeRate {
        let url = try urlType.getUrl(for: currencyCode)
        let (data, response) = try await URLSession.shared.data(from: url)
        if let response = response as? HTTPURLResponse {
            if (200..<300).contains(response.statusCode) {
                return try JSONDecoder().decode(ExchangeRate.self, from: data)
            } else if urlType == .main {
                return try await getExchangeRateFor(currencyCode: currencyCode, urlType: .fallback)
            } else {
                throw URLError(.badServerResponse)
            }
        } else {
            throw URLError(.badServerResponse)
        }
    }
}
