//
//  CurrencyConvertible.swift
//  Money
//
//  Created by Artem on 09.03.2024.
//

import Foundation

protocol CurrencyConvertible {
    var amount: Double { get }
    var currencyCode: String { get }
}

extension CurrencyConvertible {
    func getAmountWith(changeRate: Double) -> Double {
        guard changeRate != 0.0 else {
            return 0
        }
        return amount / changeRate
    }
}
