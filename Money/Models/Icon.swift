//
//  Icon.swift
//  Money
//
//  Created by Artem on 11.07.2024.
//

import Foundation

struct Icon: Equatable {
    
    enum Modifiers: String, CaseIterable {
        case fill
        case circle
        case square
        
        var withDot: String {
            "." + self.rawValue
        }
    }
    
    var name: String
    var color: SwiftColor
    var isMulticolor: Bool
    
    static func isBaseNameSame(lhs: String, rhs: String) -> Bool {
        lhs.components(separatedBy: ".").first == rhs.components(separatedBy: ".").first
    }
    
    func contains(modifier: Modifiers) -> Bool {
        name.contains(modifier.withDot)
    }
    
    func removed(modifiers: [Modifiers]) -> String {
        var modified = name
        for mod in modifiers {
            modified = modified.replacingOccurrences(of: mod.withDot, with: "")
        }
        return modified
    }
}
