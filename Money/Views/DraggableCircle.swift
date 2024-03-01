//
//  DraggableCircle.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import SwiftUI

struct DraggableCircle: View {
    var viewModel: DraggableCircleViewModel
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(.white, lineWidth: 3)
                .fill(
                    viewModel.highlighted ?
                    viewModel.item.type.highColor :
                        viewModel.item.type.color
                )
            VStack {
                Text(viewModel.item.name)
                    .font(.caption2)
                Text(prettify(location: viewModel.state.location))
            }
            .foregroundStyle(Color.white)
        }
        .scaleEffect(viewModel.state.shouldShowTouch ||
                     viewModel.highlighted ?
                     1.2 : 1.0)
        .offset(viewModel.item.type.isMovable ?
                viewModel.state.offset :
                .zero)
        .gesture(drag)
        .getRect(
            Binding(
                get: { return viewModel.initialRect.wrappedValue },
                set: { val in return viewModel.initialRect = .constant(val) }
            )
        )
        .padding(5)
    }
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .named("screen"))
            .onChanged { value in
                viewModel.state = .moving(location: value.location,
                                          offset: value.translation)
            }
            .onEnded { value in
                if value.translation.width == 0 && value.translation.height == 0 {
                    viewModel.state = .pressed
                } else {
                    viewModel.state = .released(location: value.location)
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
