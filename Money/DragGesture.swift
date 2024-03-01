////
////  DragGesture.swift
////  Money
////
////  Created by Artem on 01.03.2024.
////
//
//import SwiftUI
//
//struct Drag {
//    @GestureState var isTapped: Bool {
//        didSet {
//            print(isTapped)
//        }
//    }
//    @Binding var plusButtonState: CircleState
//    @Binding var offset: CGSize
////    @State private var isDragging = false
//    
//    var body: some View {
//        Text("Hello, World!")
//    }
//    
//    var drag: some Gesture {
//        DragGesture(minimumDistance: 0, coordinateSpace: .named("screen"))
//            .updating($isTapped) { _, isTapped, _ in
//                isTapped = true
//            }
//            .onChanged { value in
//                plusButtonState = .moving(location: value.location)
//                offset = value.translation
//                if offset == CGSize.zero {
//                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
//                }
//            }
//            .onEnded { value in
//                if value.translation.width == 0 && value.translation.height == 0 {
//                    plusButtonState = .pressed
//                } else {
//                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
//                    offset = .zero
//                    plusButtonState = .idle
//                }
//            }
//    }
//}
