//
//  CurrencyError.swift
//  Money
//
//  Created by Artem on 07.03.2024.
//

import Foundation

enum CurrencyError: Error {
    case jsonFileIsMissing
}

enum NetworkError: Error, CustomStringConvertible {
    case noInternet
    case internalError
    case decoding(error: String)
    case custom(error: String)
    
    var description: String {
        switch self {
        case .noInternet:
            return "No internet connection"
        case .internalError:
            return "Server error"
        case .custom(let error), .decoding(let error):
            return error
        }
    }
}
