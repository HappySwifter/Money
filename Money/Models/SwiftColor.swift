//
//  Color.swift
//  Money
//
//  Created by Artem on 05.03.2024.
//

import Foundation
import SwiftUI

enum SwiftColor: String, CaseIterable {
    case purple = "purple"
    case red = "red"
    case blue = "blue"
    case gray = "gray"
    
    var value: Color {
        switch self {
        case .purple:
            return .purple
        case .red:
            return .red
        case .blue:
            return .blue
        case .gray:
            return .gray
        }
    }
}
