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
        prettify(val: sourceAmount, fractionLength: 2, currencySymbol: source?.currencySymbol)
    }
    var destinationAmountText: String {
        prettify(val: destinationAmount, fractionLength: 2, currencySymbol: destination?.currencySymbol)
    }
    
    func convertAmount(to currencyCode: String, rates: ExchangeRate) -> Double {
        guard let sourceCurrency = source?.currency else {
//            assert(false)
            return 0
        }
       
        if currencyCode == sourceCurrency.code {
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

