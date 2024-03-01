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
    var offset = CGSize.zero
    var rect: Binding<CGRect> = .constant(CGRect.zero)
    var locationHandler: ((CircleState, UUID) -> ())?
    
    var draggableState = CircleState.idle {
        didSet {
            locationHandler?(draggableState, item.id)
        }
    }
    
    init(item: CircleItem) {
        self.item = item
    }
}
