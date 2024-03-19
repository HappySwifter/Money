import SwiftUI
import PlaygroundSupport

extension Date {
    var startOfMonth: Date {
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return  calendar.date(from: components)!
    }
    
}

let thisM = Date().startOfMonth



let now = Date.now

print(now >= thisM)
