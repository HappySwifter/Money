//
//  IconType.swift
//  Money
//
//  Created by Artem on 11.07.2024.
//

import Foundation

enum IconType: String, CaseIterable {
    case all
    case objectAndTools
    case devices
    case transportation
    case human
    case home
    case nature
    case health
    
    var title: String {
        switch self {
        case .objectAndTools:
            return "Object and tools"
        case .all, .devices, .transportation, .human, .home, .nature, .health:
            return rawValue.capitalized
        }
    }
    
    func getIcons() -> [String] {
        switch self {
            
        case .all:
            return Symbols.objectAndTools +
            Symbols.devices +
            Symbols.transportation +
            Symbols.human +
            Symbols.home +
            Symbols.nature +
            Symbols.health
        case .objectAndTools:
            return Symbols.objectAndTools
        case .devices:
            return Symbols.devices
        case .transportation:
            return Symbols.transportation
        case .human:
            return Symbols.human
        case .home:
            return Symbols.home
        case .nature:
            return Symbols.nature
        case .health:
            return Symbols.health
        }
    }
}
