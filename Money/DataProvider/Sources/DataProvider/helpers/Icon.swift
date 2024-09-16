//
//  Icon.swift
//  Money
//
//  Created by Artem on 11.07.2024.
//

import Foundation

public struct Icon: Equatable {
    
    public enum Modifiers: String, CaseIterable {
        case fill
        case circle
        case square
        
        var withDot: String {
            "." + self.rawValue
        }
    }
    
    public var name: String
    public var color: SwiftColor
    
    public init(name: String, color: SwiftColor) {
        self.name = name
        self.color = color
    }
    
    public static func isBaseNameSame(lhs: String, rhs: String) -> Bool {
        removeModifiers(from: lhs, modifiers: Icon.Modifiers.allCases) == removeModifiers(from: rhs, modifiers: Icon.Modifiers.allCases)
    }
    
    public func contains(modifier: Modifiers) -> Bool {
        name.contains(modifier.withDot)
    }
    
    public func removed(modifiers: [Modifiers]) -> String {
        Icon.removeModifiers(from: name, modifiers: modifiers)
    }
    
    private static func removeModifiers(from name: String, modifiers: [Modifiers]) -> String {
        var modified = name
        for mod in modifiers {
            modified = modified.replacingOccurrences(of: mod.withDot, with: "")
        }
        return modified
    }
}
