import SwiftUI
import PlaygroundSupport

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
    
    func contains(modifier: String) -> Bool {
        name.contains(modifier)
    }
    
    
    func removed(modifiers: [Modifiers]) -> String {
        var modified = name
        for mod in modifiers {
            modified = modified.replacingOccurrences(of: mod.withDot, with: "")
        }
        return modified
    }
}

let x = Icon(name: "doc.square.fill")
x.removed(modifiers: Icon.Modifiers.allCases)
