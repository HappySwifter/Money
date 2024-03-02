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
        DraggableCircleViewModel(item: CircleItem(name: "food", type: .category)),
        DraggableCircleViewModel(item: CircleItem(name: "car", type: .category)),
        DraggableCircleViewModel(item: CircleItem(name: "relax1", type: .category)),
        DraggableCircleViewModel(item: CircleItem(name: "relax2", type: .category)),
        DraggableCircleViewModel(item: CircleItem(name: "relax3", type: .category)),
        DraggableCircleViewModel(item: CircleItem(name: "relax4", type: .category)),
        DraggableCircleViewModel(item: CircleItem(name: "relax5", type: .category)),
        DraggableCircleViewModel(item: CircleItem(name: "relax6", type: .category)),
        DraggableCircleViewModel(item: CircleItem(name: "relax7", type: .category)),
        DraggableCircleViewModel(item: CircleItem(name: "relax8", type: .category)),
        DraggableCircleViewModel(item: CircleItem(name: "relax9", type: .category)),
        DraggableCircleViewModel(item: CircleItem(name: "relax10", type: .category)),
        DraggableCircleViewModel(item: CircleItem(name: "relax11", type: .category)),
        DraggableCircleViewModel(item: CircleItem(name: "relax12", type: .category)),
        DraggableCircleViewModel(item: CircleItem(name: "relax13", type: .category)),
        DraggableCircleViewModel(item: CircleItem(name: "relax14", type: .category)),
        DraggableCircleViewModel(item: CircleItem(name: "relax15", type: .category)),
        DraggableCircleViewModel(item: CircleItem(name: "relax16", type: .category)),
        DraggableCircleViewModel(item: CircleItem(name: "relax17", type: .category)),
        DraggableCircleViewModel(item: CircleItem(name: "relax18", type: .category)),
        DraggableCircleViewModel(item: CircleItem(name: "relax19", type: .category)),
        DraggableCircleViewModel(item: CircleItem(name: "relax20", type: .category))
    ]

    static let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 200)),
        GridItem(.adaptive(minimum: 100, maximum: 200)),
        GridItem(.adaptive(minimum: 100, maximum: 200)),
        GridItem(.adaptive(minimum: 100, maximum: 200)),
    ]
}


