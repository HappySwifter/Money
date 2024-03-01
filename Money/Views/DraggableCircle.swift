//
//  DraggableCircle.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import SwiftUI

struct DraggableCircle: View {
    var viewModel: DraggableCircleViewModel
    @GestureState private var isTapped = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(.white, lineWidth: 3)
                .fill(
                    viewModel.highlighted ?
                    viewModel.item.type.highColor :
                        viewModel.item.type.color
                )
            Text(viewModel.item.name)
                .font(.caption2)
                .foregroundStyle(Color.white)
        }
        .scaleEffect((isTapped || viewModel.highlighted) ? 1.2 : 1.0)
        .offset(viewModel.offset)
        .gesture(drag)
        .getRect(
            Binding(
                get: { return viewModel.rect.wrappedValue },
                set: { (newValue) in return viewModel.rect.wrappedValue = newValue }
            )
        )
        .padding(5)
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
    LazyVGrid(columns: MockData.columns, content: {
        ForEach(Array(zip(MockData.data.indices, MockData.data)), id: \.0) { index, account in
            DraggableCircle(viewModel: account)
        }
    })
}
