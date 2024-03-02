//
//  PlusButton.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import SwiftUI

struct PlusButton: View {
    var viewModel: DraggableCircleViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "plus")
                .font(.system(size: 30))
                .foregroundColor(.white)
                .padding(15)
                .background(Color.purple)
                .clipShape(Circle())
        }
        .scaleEffect(viewModel.draggableState.shouldShowTouch ||
                     viewModel.stillState == .focused ?
                     1.2 : 1.0)
        .offset(viewModel.draggableState.offset)
        .gesture(drag)
    }
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .named("screen"))
            .onChanged { value in
                viewModel.draggableState = .moving(location: value.location,
                                                   offset: value.translation)
            }
            .onEnded { value in
                if value.translation.width == 0 && value.translation.height == 0 {
                    viewModel.draggableState = .pressed
                } else {
                    withAnimation(.bouncy(duration: 0.5)) {
                        viewModel.draggableState = .released(location: value.location)
                    }
                }
            }
    }
}

#Preview {
    PlusButton(viewModel: DraggableCircleViewModel(
        item: CircleItem(name: "", type: .plusButton)))
}
