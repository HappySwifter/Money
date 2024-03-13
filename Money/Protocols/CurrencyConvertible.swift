//
//  CurrencyConvertible.swift
//  Money
//
//  Created by Artem on 09.03.2024.
//

import Foundation

protocol CurrencyConvertible {
    var accountDetails: AccountDetails? { get }
}

extension CurrencyConvertible {
    func getAmountWith(changeRate: Double) -> Double {
        guard let accountDetails, changeRate != 0.0 else {
            return 0
        }
        return accountDetails.amount / changeRate
    }
}
