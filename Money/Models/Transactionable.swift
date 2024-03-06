//
//  Transactionable.swift
//  Money
//
//  Created by Artem on 06.03.2024.
//

import Foundation

protocol Transactionable {
    func deposit(amount: Double)
    func creadit(amount: Double)
}
