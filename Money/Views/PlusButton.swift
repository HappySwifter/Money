//
//  PlusButton.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import SwiftUI

struct PlusButton: View {
    var viewModel: DraggableCircleViewModel
    @GestureState private var isTapped = false
    
    var body: some View {
        VStack {
            Image(systemName: "plus")
                .font(.system(size: 35))
                .foregroundColor(.white)
                .padding(15)
                .background(Color.purple)
                .clipShape(Circle())
        }
        .scaleEffect(isTapped ? 1.5 : 1.0)
        .offset(viewModel.offset)
        .gesture(drag)
    }
    
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .named("screen"))
            .updating($isTapped) { _, isTapped, _ in
                isTapped = true
            }
            .onChanged { value in
                viewModel.draggableState = .moving(location: value.location)
                viewModel.offset = value.translation
                if viewModel.offset == CGSize.zero {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            }
            .onEnded { value in
                if value.translation.width == 0 && value.translation.height == 0 {
                    viewModel.draggableState = .pressed
                } else {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    viewModel.offset = .zero
                    viewModel.draggableState = .idle
                }
            }
    }
}

#Preview {
    PlusButton(viewModel: DraggableCircleViewModel(
        item: CircleItem(name: "", type: .plusButton)))
}
