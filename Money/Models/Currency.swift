//
//  Currency.swift
//  Money
//
//  Created by Artem on 04.03.2024.
//

import Foundation

struct Currency: Codable, Equatable, Hashable {    
    
    static func == (lhs: Currency, rhs: Currency) -> Bool {
        lhs.code == rhs.code
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }
    
    let code: String
    let name: String
    let icon: String
    
    init(code: String, name: String, icon: String) {
        self.code = code
        self.name = name
        self.icon = icon
    }
}
