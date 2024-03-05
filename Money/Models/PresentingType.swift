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
    case addAccount
    case addCategory
    case none
    
    var sheetHeightFraction: CGFloat {
        switch self {
        case .transfer, .details:
            return 0.4
        case .addAccount, .addCategory, .none:
            return 1

        }
    }
}
