//
//  TransactionViewType.swift
//  Money
//
//  Created by Artem on 05.08.2024.
//

import Foundation
import DataProvider

enum TransactionViewType {
    case accountToCategory
    case accountToAccountSameCurrency
    case accountToAccountDiffCurrency
    
    init(source: Account, destination: Account) {
        if destination.isAccount {
            if source.getCurrency()?.code == destination.getCurrency()?.code {
                self = .accountToAccountSameCurrency
            } else {
                self = .accountToAccountDiffCurrency
            }
        } else {
            self = .accountToCategory
        }
    }
}
