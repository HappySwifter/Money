//
//  MockData.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import Foundation
import SwiftUI

struct MockData {
    static let data = [
        DraggableCircleViewModel(item: CircleItem(name: "cash", type: .account)),
        DraggableCircleViewModel(item: CircleItem(name: "bank", type: .account)),
        DraggableCircleViewModel(item: CircleItem(name: "card", type: .account)),
        DraggableCircleViewModel(item: CircleItem(name: "some5",type: .account)),
        DraggableCircleViewModel(item: CircleItem(name: "food", type: .expense)),
        DraggableCircleViewModel(item: CircleItem(name: "car", type: .expense)),
        DraggableCircleViewModel(item: CircleItem(name: "relax1", type: .expense)),
        DraggableCircleViewModel(item: CircleItem(name: "relax2", type: .expense)),
        DraggableCircleViewModel(item: CircleItem(name: "relax3", type: .expense)),
        DraggableCircleViewModel(item: CircleItem(name: "relax4", type: .expense)),
        DraggableCircleViewModel(item: CircleItem(name: "relax5", type: .expense)),
        DraggableCircleViewModel(item: CircleItem(name: "relax6", type: .expense)),
        DraggableCircleViewModel(item: CircleItem(name: "relax7", type: .expense)),
        DraggableCircleViewModel(item: CircleItem(name: "relax8", type: .expense)),
        DraggableCircleViewModel(item: CircleItem(name: "relax9", type: .expense)),
        DraggableCircleViewModel(item: CircleItem(name: "relax10", type: .expense)),
        DraggableCircleViewModel(item: CircleItem(name: "", type: .plusButton))
    ]
    
    static let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 200)),
        GridItem(.adaptive(minimum: 100, maximum: 200)),
        GridItem(.adaptive(minimum: 100, maximum: 200)),
        GridItem(.adaptive(minimum: 100, maximum: 200)),
    ]
}


