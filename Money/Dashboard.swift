//
//  Dashboard.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import Foundation
import SwiftUI


struct Dashboard: View {
    @State var viewModel: DashboardViewModel
    @State var offset = CGSize.zero
    @State private var location: CGPoint = .zero
    @State private var isDragging = false
    @GestureState private var isTapped = false
    
    var body: some View {
        VStack {
            PlusButton(location: $location)
            .scaleEffect(isTapped ? 1.5 : 1.3)
            .offset(offset)
            .gesture(drag)
            .zIndex(1)
            Spacer()
            
            HStack {
                ForEach(Array(zip(viewModel.accounts.indices, viewModel.accounts)), id: \.0) { index, account in
                    DraggableCircle(viewModel: account)
                }
            }

        }
        .coordinateSpace(name: "screen")
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
        for i in 0..<viewModel.accounts.count {
            viewModel.accounts[i].highlighted = false
        }
    }
    
    func check(offset: CGPoint) {
        let rect = CGRect(origin: offset, size: CGSize(width: 50, height: 50))
        for (index, account) in viewModel.accounts.enumerated() {
            if rect.intersects(account.origin.wrappedValue) {
                if viewModel.accounts[index].highlighted == false {
                    resetHight()
                    viewModel.accounts[index].highlighted = true
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            } else {
                viewModel.accounts[index].highlighted = false
            }
        }
    }
    
    func prettify(location: CGPoint?) -> String {
        guard let location = location else { return "" }
        return "\(String(format: "%.0f", location.x)) \(String(format: "%.0f", location.y))"
    }
}

@Observable
class DashboardViewModel {
    var accounts: [DraggableCircleViewModel]
    
    init(accounts: [DraggableCircleViewModel]) {
        self.accounts = accounts
    }
}


#Preview {
    Dashboard(viewModel: DashboardViewModel(accounts: MockData.draggableCircleViewModels))
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
