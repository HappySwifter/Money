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
                .background(viewModel.item.type.color)
                .clipShape(Circle())
        }
        .opacity(viewModel.stillState.opacity)
        .scaleEffect(viewModel.draggableState.shouldShowTouch ||
                     viewModel.stillState == .focused ?
                     1.2 : 1.0)
        .offset(viewModel.draggableState.offset)
        .gesture(Drag(state: Binding(get: {
            viewModel.draggableState
        }, set: { val in
            viewModel.draggableState = val
        })).drag)
    }

}

#Preview {
    PlusButton(viewModel: DraggableCircleViewModel(
        item: CircleItem(name: "", type: .plusButton)))
}
