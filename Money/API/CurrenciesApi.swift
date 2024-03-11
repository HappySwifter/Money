//
//  CurrenciesApi.swift
//  Money
//
//  Created by Artem on 04.03.2024.
//

import Foundation
import SwiftData
import OSLog

@Observable
class CurrenciesApi {
    private var logger = Logger(subsystem: "Money", category: "CurrenciesApi")
    private var currencies: [MyCurrency]?
    private var preferences: Preferences
    
    @ObservationIgnored
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext, preferences: Preferences) {
        self.modelContext = modelContext
        self.preferences = preferences
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
    
    func getCurrencies() throws -> [MyCurrency] {
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
                    return MyCurrency(code: key, name: value, icon: "")
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
    
    func getExchangeRateFor(currencyCode: String, date: Date, urlType: ExchangeRateUrlType = .main) async throws -> ExchangeRate {
        if let data = preferences.getRates(date: date.ratesDateString, currency: currencyCode) {
            logger.info("Using rates from cache")
            return try decodeRates(from: data)
        }
        logger.info("Loading rates")
        let url = try urlType.getUrl(for: currencyCode)
        let (data, response) = try await URLSession.shared.data(from: url)
        if let response = response as? HTTPURLResponse {
            if (200..<300).contains(response.statusCode) {
                let rate = try decodeRates(from: data)
                
                preferences.setRates(data: data,
                                     date: date.ratesDateString,
                                     currency: currencyCode)
                return rate
            } else if urlType == .main {
                return try await getExchangeRateFor(currencyCode: currencyCode,
                                                    date: date,
                                                    urlType: .fallback)
            } else {
                throw URLError(.badServerResponse)
            }
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    private func decodeRates(from data: Data) throws -> ExchangeRate {
        return try JSONDecoder().decode(ExchangeRate.self, from: data)
    }
}
