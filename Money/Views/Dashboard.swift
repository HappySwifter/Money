//
//  Dashboard.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import Foundation
import SwiftUI

struct Dashboard: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var viewModel: DashboardViewModel
    
    var columns: [GridItem] {
        let count: Int
        switch horizontalSizeClass {
        case .compact:
            count = 4
        case .regular:
            count = 8
        default:
            count = 0
        }
        return Array(repeating: .init(.flexible(minimum: 60, maximum: 150)), count: count)
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                PlusButton(viewModel: viewModel.plusButton)
            }
            .zIndex(100)
            
            
            if viewModel.showDropableLocations {
                DropableView(highlighted: .constant(true), type: .account)
            } else {
                HStack {
                    Text("Accounts")
                    Text("$124.420")
                    Spacer()
                }
            }
            
            HStack {
                ForEach(viewModel.accounts, id: \.item) { acc in
                    DraggableCircle(viewModel: acc)
                }
            }
            .zIndex(1)
            
            Divider()
                .padding(.vertical)
            
            if viewModel.showDropableLocations {
                DropableView(highlighted: .constant(false), type: .category)
            } else {
                HStack {
                    Text("This month")
                    Text("-$123")
                    Spacer()
                }
            }
            
            ScrollView {
                LazyVGrid(columns: columns, content: {
                    ForEach(viewModel.expenses, id: \.item) { exp in
                        DraggableCircle(viewModel: exp)
                    }
                    .zIndex(-1)
                })
            }
        }
        .coordinateSpace(name: "screen")
        .padding()
        .sheet(isPresented: viewModel.sheetBinding,
               content: {
            SendMoneyView(amount: Binding(get: {
                viewModel.newAmount
            }, set: { val, _ in
                viewModel.newAmount = val
            }), isPresented: viewModel.sheetBinding)
        })
    }
}

@Observable
class DashboardViewModel {
    var data: [DraggableCircleViewModel]
    var accounts: [DraggableCircleViewModel]
    var expenses: [DraggableCircleViewModel]
    var plusButton: DraggableCircleViewModel
    var sheetPresended = false
    var showDropableLocations = false
    var newAmount = ""
    
    var sheetBinding: Binding<Bool> {
        Binding(
            get: { return self.sheetPresended },
            set: { (newValue) in return self.sheetPresended = newValue }
        )
    }
    
    
    private let movingItemSize = CGSize(width: 1, height: 1)
    private let plusButtonOffsetThreshold = 20.0
    private let animation = Animation.smooth(duration: 0.3)
    
    init(data: [DraggableCircleViewModel]) {
        self.data = data
        self.accounts = data.filter { $0.item.type == .account }
        self.expenses = data.filter { $0.item.type == .category }
        self.plusButton = data.filter { $0.item.type == .plusButton }.first!
        
        for datum in data {
            datum.locationHandler = handle(movingItem:state:)
        }
    }
    
    private func handle(movingItem: CircleItem, state: CircleState) {
        
        switch state {
        case .released(let location):
            resetHight()
            showImpact()
            if shouldPresentSheet(movingItem: movingItem, location: location) {
                sheetPresended = true
            }
            updateDropableLocations(plusButtonOffset: .zero)
        case .pressed:
            sheetPresended = true
        case .moving(let location, let offset):
            if offset == .zero { showImpact() }
            
            if movingItem.type == .plusButton {
                updateDropableLocations(plusButtonOffset: offset)
            }
            if movingItem.type.isMovable {
                highlighted(location: location, movingItem: movingItem)
            }
        }
    }
    
    private func updateDropableLocations(plusButtonOffset: CGSize) {
        withAnimation(animation) {
            showDropableLocations =
            abs(plusButtonOffset.width) > plusButtonOffsetThreshold ||
            abs(plusButtonOffset.height) > plusButtonOffsetThreshold
        }
    }
    
    private func highlighted(location: CGPoint, movingItem: CircleItem) {
        let rect = CGRect(origin: location, size: movingItemSize)
        
        for (index, datum) in data.enumerated() {
            if rect.intersects(datum.initialRect) {
                if datum.item != movingItem &&
                    canTrigger(movingItem: movingItem, stillItem: datum.item) &&
                    data.filter({ $0.highlighted }).isEmpty {
                    data[index].highlighted = true
                    showImpact()
                }
            } else {
                data[index].highlighted = false
            }
        }
    }
    
    private func canTrigger(movingItem: CircleItem, stillItem: CircleItem) -> Bool {
        if movingItem.type == .plusButton && stillItem.type == .category ||
            movingItem.type == .category {
            return false
        } else {
            return true
        }
    }
    
    private func shouldPresentSheet(movingItem: CircleItem, location: CGPoint) -> Bool {
        let rect = CGRect(origin: location, size: movingItemSize)
        let intersectedModel = data
            .filter { rect.intersects($0.initialRect) }
            .filter { canTrigger(movingItem: movingItem, stillItem: $0.item) }
            .first
        if let interspectedModel = intersectedModel,
           interspectedModel.item != movingItem {
            return true
        } else {
            return false
        }
    }
    
    
    private func resetHight() {
        for i in 0..<data.count {
            data[i].highlighted = false
        }
    }
}


#Preview {
    Dashboard(viewModel: DashboardViewModel(data: MockData.data))
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
