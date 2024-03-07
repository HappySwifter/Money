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
}
