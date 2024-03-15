//
//  Currency.swift
//  Money
//
//  Created by Artem on 04.03.2024.
//

import Foundation
import SwiftData

@Model
final class MyCurrency {
    let code: String
    let name: String
    let symbol: String
    
    init(code: String, name: String, symbol: String) {
        self.code = code
        self.name = name
        self.symbol = symbol
    }
}
