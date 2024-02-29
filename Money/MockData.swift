//
//  MockData.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import Foundation
import SwiftUI

struct MockData {
    static let accounts = [
        DraggableCircleViewModel(name: "cash", type: .account),
        DraggableCircleViewModel(name: "bank", type: .account),
        DraggableCircleViewModel(name: "card", type: .account),
        DraggableCircleViewModel(name: "some5",type: .account)
    ]
    
    static let expenses = [
        DraggableCircleViewModel(name: "food", type: .expense),
        DraggableCircleViewModel(name: "car", type: .expense),
        DraggableCircleViewModel(name: "relax1", type: .expense),
        DraggableCircleViewModel(name: "relax2", type: .expense),
        DraggableCircleViewModel(name: "relax3", type: .expense),
        DraggableCircleViewModel(name: "relax4", type: .expense),
        DraggableCircleViewModel(name: "relax5", type: .expense),
        DraggableCircleViewModel(name: "relax6", type: .expense),
        DraggableCircleViewModel(name: "relax7", type: .expense),
        DraggableCircleViewModel(name: "relax8", type: .expense),
        DraggableCircleViewModel(name: "relax9", type: .expense),
        DraggableCircleViewModel(name: "relax10", type: .expense),
    ]
    
    static let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 200)),
        GridItem(.adaptive(minimum: 100, maximum: 200)),
        GridItem(.adaptive(minimum: 100, maximum: 200)),
        GridItem(.adaptive(minimum: 100, maximum: 200)),
    ]
}


