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
    var stillRect = CGRect.zero
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
    
    func setNormal() {
        stillState = .normal
    }

    func updateStillItemState(movingItemType: CircleType,
                              movingItemState: DraggableCircleState,
                              noFocusedItems: Bool)
    {
        switch movingItemState {
        case .pressed, .released:
            return
        case .moving:
            break
        }
        
        let movingOffset = movingItemState.offset
        let movingLocation = movingItemState.location
        let movingItemSize = CGSize(width: 1, height: 1)
        let movingRect = CGRect(origin: movingLocation,
                                size: movingItemSize)
        let stillItemType = self.item.type
        withAnimation {
            switch (movingItemType, stillItemType) {
            case (.plusButton, .category):
                if abs(movingOffset.width) > 20 || abs (movingOffset.height) > 20 {
                    stillState = .disabled
                } else {
                    setNormal()
                }
                
            case (.account, .plusButton):
                if abs(movingOffset.width) > 20 || abs (movingOffset.height) > 20 {
                    stillState = .disabled
                } else {
                    setNormal()
                }
            default:
                if movingRect.intersects(stillRect) {
                    if movingItemType.canTrigger(type: stillItemType) && noFocusedItems {
                        stillState = .focused
                        showImpact()
                    }
                } else {
                    setNormal()
                }
            }

        }
    }
}
