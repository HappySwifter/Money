//
//  Transaction.swift
//  Money
//
//  Created by Artem on 06.03.2024.
//

import Foundation
import DataProvider

extension MyTransaction {
    var sourceAmountText: String {
        prettify(val: sourceAmount, fractionLength: 2, currencySymbol: source?.getCurrency()?.symbol)
    }
    var destinationAmountText: String {
        prettify(val: destinationAmount, fractionLength: 2, currencySymbol: destination?.getCurrency()?.symbol)
    }
    
    func convertAmount(to currency: AccountCurrency, rates: ExchangeRate) -> Double {
        guard let sourceCurrency = source?.getCurrency() else {
//            assert(false)
            return 0
        }
       
        if currency.code == sourceCurrency.code {
            return sourceAmount
        } else {
            if let exchRate = rates.value(for: sourceCurrency.code) {
                return sourceAmount / exchRate
            } else {
//                assert(false, "ERROR no rate for code \(sourceCurrency.code)")
                return 0
            }
        }
    }
}

