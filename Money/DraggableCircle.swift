//
//  DraggableCircle.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import SwiftUI

struct DraggableCircle: View {
    var viewModel: DraggableCircleViewModel
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
                .font(.caption2)
            //                Text(prettify(location: viewModel.origin.wrappedValue.origin))
            //                    .font(.caption2)
            
            //            }
                .foregroundStyle(Color.white)
        }
        .scaleEffect((isTapped || viewModel.highlighted) ? 1.2 : 1.0)
        .offset(viewModel.offset)
        .gesture(drag)
//        .zIndex(viewModel.draggableState == .moving(location: <#T##CGPoint#>) ? 100 : 0)
        .getRect(
            Binding(
                get: { return viewModel.rect.wrappedValue },
                set: { (newValue) in return viewModel.rect = .constant(newValue) }
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
                viewModel.draggableState = .moving(location: value.location)
                viewModel.offset = value.translation
                if viewModel.offset == CGSize.zero {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            }
            .onEnded { value in
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                viewModel.offset = .zero
                viewModel.draggableState = .idle
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
    var offset = CGSize.zero
    var rect: Binding<CGRect> = .constant(CGRect.zero)
    var locationHandler: ((DraggableState) -> ())?
    
    var draggableState = DraggableState.idle {
        didSet {
            locationHandler?(draggableState)
        }
    }
    
    init(name: String, type : CircleType) {
        self.name = name
        self.type = type
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
        ForEach(Array(zip(MockData.data.indices, MockData.data)), id: \.0) { index, account in
            DraggableCircle(viewModel: account)
        }
    })
}
