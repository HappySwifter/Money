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
        
    var body: some View {
        ZStack {
            Circle()
                .stroke(.white, lineWidth: 3)
                .fill(
                    viewModel.highlighted ?
                    viewModel.type.highColor :
                    viewModel.type.color
                )
//            VStack {
                Text(viewModel.name)
//                Text(prettify(location: viewModel.origin.wrappedValue.origin))
//                    .font(.caption2)

//            }
            .foregroundStyle(Color.white)
        }
        .scaleEffect((isTapped || viewModel.highlighted) ? 1.2 : 1.0)
        .offset(offset)
        .gesture(drag)
        .zIndex(viewModel.isMoving ? 100 : 0)
        .getRect(
            Binding(
                get: { return viewModel.origin.wrappedValue },
                set: { (newValue) in return viewModel.origin = .constant(newValue) }
            )
        )
        .padding(5)
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
    let type : CircleType
    var highlighted = false
    var isMoving: Bool
    var location = CGPoint.zero

    var origin: Binding<CGRect> = .constant(CGRect.zero)
    
    init(name: String, isMoving: Bool = false, type : CircleType) {
        self.name = name
        self.type = type
        self.isMoving = isMoving
    }
}

enum CircleType {
    case account
    case expense
    
    var color: Color {
        switch self {
        case .account:
            return .green
        case .expense:
            return .red
        }
    }
    
    var highColor: Color {
        switch self {
        case .account:
            return .green.opacity(0.3)
        case .expense:
            return .red.opacity(0.3)
        }
    }
}

#Preview {
    LazyVGrid(columns: MockData.columns, content: {
        ForEach(Array(zip(MockData.accounts.indices, MockData.accounts)), id: \.0) { index, account in
            DraggableCircle(viewModel: account)
                .zIndex(account.isMoving ? 1 : -1)
        }
    })
}
