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
    public var isMulticolor: Bool
    
    public init(name: String, color: SwiftColor, isMulticolor: Bool) {
        self.name = name
        self.color = color
        self.isMulticolor = isMulticolor
    }
    
    public static func isBaseNameSame(lhs: String, rhs: String) -> Bool {
        lhs.components(separatedBy: ".").first == rhs.components(separatedBy: ".").first
    }
    
    public func contains(modifier: Modifiers) -> Bool {
        name.contains(modifier.withDot)
    }
    
    public func removed(modifiers: [Modifiers]) -> String {
        var modified = name
        for mod in modifiers {
            modified = modified.replacingOccurrences(of: mod.withDot, with: "")
        }
        return modified
    }
}
