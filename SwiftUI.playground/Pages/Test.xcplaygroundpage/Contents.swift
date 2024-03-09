//: [Previous](@previous)

import Foundation

let json =
"""
{
    "date": "2024-03-03",
    "eur": {
        "$myro": 7.78838571,
        "$wen": 6090.24155509,
        "00": 14.6038358,
        "1000sats": 1701.80722486,
        "1inch": 1.90000353,
        "aave": 0.0092880383,
        "abt": 0.62831292,
        "ach": 36.87812256,
        "acs": 336.24573908,
        "ada": 1.48201187,
        "aed": 3.98182257,
        "aergo": 6.08561413,
        "aero": 2.13643837,
        "afn": 79.59500926
    }
}
"""

import Foundation

public struct Rates: Codable {
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
        
        date = try container.decode(String.self, forKey: CustomCodingKeys(stringValue: "date")!)

        
        self.currency = [String: [String: Double]]()
        for key in container.allKeys {
            if let value = try? container.decode([String: Double].self, forKey: CustomCodingKeys(stringValue: key.stringValue)!) {
                self.currency[key.stringValue] = value
            }
        }
    }
}

//let data = try JSONDecoder().decode(Rates.self, from: json.data(using: .utf8)!)
//data.currency["eur"]?["$myro"]

for i in 1..<5 {
    print(i)
}
