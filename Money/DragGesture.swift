//
//  DragGesture.swift
//  Money
//
//  Created by Artem on 01.03.2024.
//

import SwiftUI

struct Drag {
    @Binding var state: DraggableCircleState
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .named("screen"))
            .onChanged {
                state = .moving(location: $0.location, offset: $0.translation)
            }
            .onEnded { value in
                if value.translation.width == 0 && value.translation.height == 0 {
                    state = .pressed
                } else {
                    withAnimation(.bouncy(duration: 0.4)) {
                        state = .released(location: value.location)
                    }
                }
            }
    }
}
