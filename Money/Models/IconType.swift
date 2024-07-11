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
    case accounts
    case currencies
    
    var title: String {
        switch self {
        case .objectAndTools:
            return "Object and tools"
        case .all, .devices, .transportation, .human, .home, .nature, .health, .accounts, .currencies:
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
            Symbols.health +
            Symbols.accounts +
            Symbols.currencies
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
        case .accounts:
            return Symbols.accounts
        case .currencies:
            return Symbols.currencies
        }
    }
}
