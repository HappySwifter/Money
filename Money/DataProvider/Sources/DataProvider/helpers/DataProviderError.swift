//
//  File.swift
//  
//
//  Created by Artem on 24.07.2024.
//

import Foundation

public enum DataProviderError: String, Error {
    case unknownTransactionType = "No unknown type should exists"
    case transactionSourceMissing = "transactionSourceMissing"
    case transactionDestinationMissing = "transactionDestinationMissing"
    case transactionDestinationAmountMissing = "transactionDestinationAmountMissing"
}
