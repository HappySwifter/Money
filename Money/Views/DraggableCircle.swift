//
//  DraggableCircle.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import SwiftUI

struct DraggableCircle: View {
    var viewModel: DraggableItemViewModel

    var body: some View {
//        ZStack {
//            Circle()
//                .stroke(.white, lineWidth: 3)
//                .fill(viewModel.item.type.color)
//            VStack {
//                Text(viewModel.item.icon)
//                    .font(.system(size: 35))
//                Text(viewModel.item.name)
//                    .font(.title3)
//                    .foregroundStyle(Color.white)
//            }
//        }
        VStack {
            VStack {
                Text(viewModel.item.icon)
                    .font(.system(size: 45))
                Text(viewModel.item.name)
                    .font(.title3)
                    .foregroundStyle(Color.gray)
                if viewModel.item.type == .account {
                    Text(prettify(val: viewModel.item.amount))
                }
            }
            .padding(10)

        }
        .frame(maxWidth: 100, maxHeight: 120)

        .background(SwiftColor(rawValue: viewModel.item.color)!.value.opacity(0.2))
        .clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
        .zIndex(viewModel.draggableState.isMoving ? 1 : -1)
        .opacity(viewModel.stillState.opacity)
        .scaleEffect(viewModel.draggableState.isMoving ||
                     viewModel.stillState == .focused ?
                     1.1 : 1.0)
        .offset(viewModel.draggableState.offset)
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
