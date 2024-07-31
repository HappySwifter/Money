//
//  Account.swift
//  Money
//
//  Created by Artem on 01.03.2024.
//

import Foundation
import SwiftUI
import DataProvider

extension Account : CurrencyConvertible {}

//MARK: for views
extension Account {
    var nameColor: Color {
        hid ? .gray.opacity(0.5) : Color("text_color")
    }
}
