//
//  CurrenciesApi.swift
//  Money
//
//  Created by Artem on 04.03.2024.
//

import Foundation
import SwiftData
import OSLog
import Observation

@Observable
class CurrenciesApi {
    @ObservationIgnored
    private var logger = Logger(subsystem: "Money", category: "CurrenciesApi")
    @ObservationIgnored
    private var preferences: Preferences
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
                    .appending(path: "\(currencyCode.lowercased())")
                    .appendingPathExtension("json")
            } else {
                throw URLError(.badURL)
            }
        }
    }
    
    func getCurrencies() throws -> [MyCurrency] {
        let fetchDesc = FetchDescriptor<MyCurrency>()
        return try modelContext.fetch(fetchDesc)
    }
        
    func getExchangeRateFor(currencyCode: String, date: Date, urlType: ExchangeRateUrlType = .main) async throws -> ExchangeRate {
        if let data = preferences.getRates(date: date.ratesDateString, currency: currencyCode) {
//            logger.info("Using rates from cache")
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
