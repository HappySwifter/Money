//
//  CircleItem.swift
//  Money
//
//  Created by Artem on 01.03.2024.
//

import Foundation

struct CircleItem: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let icon: String
    let type: CircleType
    
    init(id: UUID = UUID(), name: String, icon: String = "", type: CircleType) {
        self.id = id
        self.name = name
        self.icon = icon
        self.type = type
    }
}
