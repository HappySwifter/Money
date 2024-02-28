//
//  DraggableCircle.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import SwiftUI

struct DraggableCircle: View {
    @Binding var viewModel: DraggableCircleViewModel
    @Binding var position: String
    
    @State var offset = CGSize.zero
    @GestureState private var isTapped = false

    private let baseColor = Color.red
    private let hoverColor = Color.orange
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(viewModel.highlighted ? hoverColor : baseColor)
                .frame(width: 60, height: 60)
            VStack {
                Text(viewModel.name)
                Text(position)
            }
            .foregroundStyle(Color.white)
        }
        .scaleEffect(isTapped ? 1.5 : 1.3)
        .offset(offset)
        .gesture(drag)
        .zIndex(viewModel.isMoving ? 1 : -1)
    }
    
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .named("screen"))
            .updating($isTapped) { _, isTapped, _ in
                isTapped = true
            }
            .onChanged { value in
                viewModel.location = value.location
                offset = value.translation
                if offset == CGSize.zero {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
                viewModel.isMoving = true
            }
            .onEnded { value in
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                offset = .zero
                viewModel.isMoving = false
            }
    }
}

@Observable
class DraggableCircleViewModel {
    let name: String
    var highlighted = false
    var isMoving = false
    var location = CGPoint.zero
    
    init(name: String) {
        self.name = name
    }
}

#Preview {
    HStack {
        ForEach(0..<4) { _ in
            DraggableCircle(
                viewModel: .constant(DraggableCircleViewModel(name: "bank")),
                position: .constant("0, 0")
            )
            .padding()
        }
    }
    
    
}
