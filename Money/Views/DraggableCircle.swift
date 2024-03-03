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
                .fill(viewModel.item.type.color)
            VStack {
                Text(viewModel.item.icon)
                    .font(.system(size: 35))
                Text(viewModel.item.name)
                    .font(.title3)
                    .foregroundStyle(Color.white)
            }
        }
        .opacity(viewModel.stillState.opacity)
        .scaleEffect(viewModel.draggableState.shouldShowTouch ||
                     viewModel.stillState == .focused ?
                     1.2 : 1.0)
        .offset(viewModel.draggableState.offset)
        .padding(5)
        .gesture(viewModel.item.type.isMovable ?
                 Drag(state: Binding(get: {
            viewModel.draggableState
        }, set: { val in
            viewModel.draggableState = val
        })).drag : nil)
        .gesture(!viewModel.item.type.isMovable ? tap : nil)
        .getRect { viewModel.stillRect = $0 }
    }
    
    var tap: some Gesture {
        TapGesture().onEnded {
            viewModel.draggableState = .pressed
            showImpact()
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
