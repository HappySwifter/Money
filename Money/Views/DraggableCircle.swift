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
                    viewModel.stillState.color(for: viewModel.item.type)
                )
            VStack {
                Text(viewModel.item.name)
                    .font(.caption2)
                Text(prettify(location: viewModel.initialRect.origin))
                    .font(.caption2)
            }
            .foregroundStyle(Color.white)
        }
        .scaleEffect(viewModel.draggableState.shouldShowTouch ||
                     viewModel.stillState == .focused ?
                     1.2 : 1.0)
        .offset(viewModel.draggableState.offset)
        .padding(5)
        .gesture(viewModel.item.type.isMovable ? drag : nil)
        .gesture(!viewModel.item.type.isMovable ? tap : nil)
        .getRect()
        .onPreferenceChange(OriginKey.self, perform: { value in
            viewModel.initialRect = value
        })
    }
    
    var tap: some Gesture {
        TapGesture().onEnded {
            viewModel.draggableState = .pressed
            showImpact()
        }
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
                    viewModel.draggableState = .released(location: value.location)
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
