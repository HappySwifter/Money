//
//  Dashboard.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import Foundation
import SwiftUI


struct Dashboard: View {
    @State var offset = CGSize.zero
    @State private var location: CGPoint = .zero
    @State private var isDragging = false
    
    @GestureState private var isTapped = false
    
    @State private var frames = [CGRect]()
    
    @State var accounts = [
        DraggableCircleViewModel(name: "cash"),
        DraggableCircleViewModel(name: "bank"),
        DraggableCircleViewModel(name: "card"),
        DraggableCircleViewModel(name: "crypto")
    ]
    
    var body: some View {
        VStack {
            HStack {
                ForEach(Array(zip(accounts.indices, accounts)), id: \.0) { index, account in
                    DraggableCircle(
                        viewModel: .constant(account),
                        position: prettify(location: frames[safe: index]?.origin)
                    )
                    .overlay(
                        GeometryReader { geo in
                            let frame = geo.frame(in: .named("screen"))
                            Color.clear
                                .task(id: frame) {
                                    frames.insert((frame), at: 0)
                                    frames.sort { $0.minX < $1.minX }
                                    print(frames)
                                }
                        }
                    )
                    .padding()
                }
            }
            PlusButton(location: $location)
            .scaleEffect(isTapped ? 1.5 : 1.3)
            .offset(offset)
            .gesture(drag)
        }
        .coordinateSpace(name: "screen")
        .background(.gray.opacity(0.05))
    }
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .named("screen"))
            .updating($isTapped) { _, isTapped, _ in
                isTapped = true
            }
            .onChanged { value in
                location = value.location
                offset = value.translation
                if offset == CGSize.zero {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
                check(offset: location)
            }
            .onEnded { value in
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                offset = .zero
                resetHight()
            }
    }
    
    
    private func resetHight() {
        for i in 0..<accounts.count {
            accounts[i].highlighted = false
        }
    }
    
    func check(offset: CGPoint) {
        let rect = CGRect(origin: offset, size: CGSize(width: 50, height: 50))
        for (index, frame) in frames.enumerated() {
            if rect.intersects(frame) {
                if accounts[index].highlighted == false {
                    resetHight()
                    accounts[index].highlighted = true
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            } else {
                accounts[index].highlighted = false
            }
        }
    }
    
    func prettify(location: CGPoint?) -> Binding<String> {
        guard let location = location else { return .constant("") }
        return .constant("\(String(format: "%.0f", location.x)) \(String(format: "%.0f", location.y))")
    }
}


#Preview {
    Dashboard()
}



//                .gesture(LongPressGesture().onChanged { _ in self.isTapped.toggle()})

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
