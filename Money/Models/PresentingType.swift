//
//  PresentingType.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import Foundation

enum PresentingType: Equatable {
    case transfer(source: CircleItem?, destination: CircleItem?)
    case details(item: CircleItem)
    case addItem
    case none
}
