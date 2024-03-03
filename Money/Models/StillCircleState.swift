//
//  StillCircleState.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import Foundation
import SwiftUI

enum StillCircleState {
    case normal
    case focused
    case disabled
    
    var opacity: CGFloat {
        switch self {
        case .normal:
            0.8
        case .focused:
            1.0
        case .disabled:
            0.1
        }
    }
}
