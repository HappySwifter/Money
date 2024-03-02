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
    var initialRect = CGRect.zero
    var locationHandler: ((CircleItem, DraggableCircleState) -> ())?
    
    private(set) var stillState = StillCircleState.normal
    var draggableState = DraggableCircleState.released(location: .zero) {
        didSet {
            locationHandler?(item, draggableState)
        }
    }
    
    init(item: CircleItem) {
        self.item = item
    }
    
    func unFocus() {
        stillState = .normal
    }
    
    func setFocus() {
        stillState = .focused
    }
}
