//
//  DraggableCircleViewModel.swift
//  Money
//
//  Created by Artem on 01.03.2024.
//

import Foundation
import SwiftUI

@Observable
class DraggableCircleViewModel {
    let item: CircleItem
    var highlighted = false
    var initialRect = CGRect.zero
    var locationHandler: ((CircleItem, CircleState) -> ())?
    var state = CircleState.released(location: .zero) {
        didSet {
            locationHandler?(item, state)
        }
    }
    
    init(item: CircleItem) {
        self.item = item
    }
}
