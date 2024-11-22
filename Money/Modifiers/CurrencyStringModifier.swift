//
//  CurrencyStringModifier.swift
//  Money
//
//  Created by Artem on 21.11.2024.
//

import Foundation

struct CurrencyStringModifier {
    static func formatAmount(_ number: String) -> String {
        let threeSymbolsRegex = try! Regex(#",.{5}"#)
        let zeroRegex = try! Regex(#"^0[^.,]*\d{1,}"#)
        
        if number.isEmpty {
            return "0"
        } else if number == "00" {
            return "0"
        } else if number.contains(zeroRegex) {
            return String(number.dropFirst())
        } else if number.contains(threeSymbolsRegex) || (number.filter { $0 == "," }.count > 1 && number.last == ",") {
            return String(number.dropLast())
        } else {
            return number
        }
    }
}
