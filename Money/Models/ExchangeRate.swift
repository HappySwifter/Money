//
//  ExchangeRate.swift
//  Money
//
//  Created by Artem on 09.03.2024.
//

import Foundation

public struct ExchangeRate: Codable {
    public let date : String
    public var currency: [String: [String: Double]]

    private struct CustomCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)
        
        self.date = try container.decode(String.self, forKey: CustomCodingKeys(stringValue: "date")!)
        self.currency = [String: [String: Double]]()
        for key in container.allKeys {
            if let value = try? container.decode([String: Double].self, forKey: CustomCodingKeys(stringValue: key.stringValue)!) {
                self.currency[key.stringValue] = value
            }
        }
    }
}
