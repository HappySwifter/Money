//
//  DraggableCircle.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import SwiftUI

struct DraggableCircle: View {
    var viewModel: DraggableCircleViewModel
    
    @State var offset = CGSize.zero
    @GestureState private var isTapped = false

    private let baseColor = Color.red
    private let hoverColor = Color.orange
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(.white, lineWidth: 3)
                .fill(viewModel.highlighted ? hoverColor : baseColor)
                .frame(width: 60, height: 60)

            VStack {
                Text(viewModel.name)
                Text(prettify(location: viewModel.origin.wrappedValue.origin))
                    .font(.caption2)

            }
            .foregroundStyle(Color.white)
        }
        .scaleEffect(isTapped ? 1.5 : 1.3)
        .offset(offset)
        .gesture(drag)
        .zIndex(viewModel.isMoving ? 1 : -1)
        .getOrigin(
        
            Binding(
                get: { return viewModel.origin.wrappedValue },
                set: { (newValue) in return viewModel.origin = .constant(newValue) }
            )
            
        )
        .padding()
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
    
    func prettify(location: CGPoint?) -> String {
        guard let location = location else { return "" }
        return "\(String(format: "%.0f", location.x)) \(String(format: "%.0f", location.y))"
    }
}

@Observable
class DraggableCircleViewModel {
    let name: String
    var highlighted = false
    var isMoving = false
    var location = CGPoint.zero

    var origin: Binding<CGRect> = .constant(CGRect.zero)
    
    init(name: String) {
        self.name = name
    }
}

#Preview {
    HStack {
        ForEach(0..<4) { _ in
            DraggableCircle(viewModel:
                DraggableCircleViewModel(name: "bank")
            )
            .padding()
        }
    }
    
    
}
