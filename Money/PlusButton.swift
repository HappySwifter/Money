//
//  PlusButton.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import SwiftUI

struct PlusButton: View {
    @Binding var plusButtonState: DraggableState
    
    @State private var offset = CGSize.zero
    @State private var isDragging = false
    @GestureState private var isTapped = false
    
    var body: some View {
        VStack {
//            Text(prettify(location: location))
            Image(systemName: "plus")
                .font(.system(size: 35))
                .foregroundColor(.white)
                .padding(15)
                .background(Color.purple)
                .clipShape(Circle())
        }
        .scaleEffect(isTapped ? 1.5 : 1.0)
        .offset(offset)
        .gesture(drag)
    }
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .named("screen"))
            .updating($isTapped) { _, isTapped, _ in
                isTapped = true
            }
            .onChanged { value in
                plusButtonState = .moving(location: value.location)
                offset = value.translation
                if offset == CGSize.zero {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            }
            .onEnded { value in
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                offset = .zero
                plusButtonState = .idle
            }
    }
    
    func prettify(location: CGPoint?) -> String {
        guard let location = location else { return "" }
        return "\(String(format: "%.0f", location.x)) \(String(format: "%.0f", location.y))"
    }
    
}

#Preview {
    PlusButton(plusButtonState: .constant(.idle))
}
