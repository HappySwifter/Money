//
//  CircleItem.swift
//  Money
//
//  Created by Artem on 01.03.2024.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class CircleItem {
    let id: UUID
    let date: Date
    let name: String
    let icon: String
    let type: CircleType
    let color: String
    
    init(id: UUID = UUID(), date: Date = Date(), name: String, icon: String = "", type: CircleType, color: String = "blue") {
        self.id = id
        self.date = date
        self.name = name
        self.icon = icon
        self.type = type
        self.color = color
    }
}
