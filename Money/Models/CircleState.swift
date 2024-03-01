//
//  Circlable.swift
//  Money
//
//  Created by Artem on 01.03.2024.
//

import Foundation

enum CircleState: Equatable {
    case released(location: CGPoint)
    case pressed
    case moving(location: CGPoint, offset: CGSize)
//    case covered
    
    var shouldShowTouch: Bool {
        switch self {
        case .released, .pressed:
            return false
        case .moving(_, _):
            return true
        }
    }
    
    var offset: CGSize {
        switch self {
        case .released, .pressed:
            return .zero
        case .moving(_, let offset):
            return offset
        }
    }
    
    var location: CGPoint {
        switch self {
        case .pressed:
            return .zero
        case .moving(let location, _), .released(let location):
            return location
        }
    }
}
