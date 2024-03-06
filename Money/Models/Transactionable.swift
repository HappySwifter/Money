//
//  Transactionable.swift
//  Money
//
//  Created by Artem on 06.03.2024.
//

import Foundation

protocol Transactionable {
    var name: String { get }
    var icon: String { get }
    var type: ItemType { get }
    func deposit(amount: Double)
    func creadit(amount: Double)
}

enum ItemType {
    case account, category
}
