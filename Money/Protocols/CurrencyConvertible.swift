//
//  CurrencyConvertible.swift
//  Money
//
//  Created by Artem on 09.03.2024.
//

import Foundation
import DataProvider

protocol CurrencyConvertible {
    var amount: Double { get }
    var currency: MyCurrency? { get }
}

extension CurrencyConvertible {
    func getAmountWith(changeRate: Double) -> Double {
        guard changeRate != 0.0 else {
            return 0
        }
        return amount / changeRate
    }
}
