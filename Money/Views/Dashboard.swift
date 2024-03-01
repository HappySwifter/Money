//
//  Dashboard.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import Foundation
import SwiftUI

enum CircleState: Equatable {
    case idle
    case pressed
    case moving(location: CGPoint)
}

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
            LazyVGrid(columns: columns, content: {
                Section {
                    ForEach(viewModel.accounts, id: \.item) { acc in
                        DraggableCircle(viewModel: acc)
                    }
                } header: {
                    HStack {
                        Text("Accounts")
                        Text("$124.420")
                        Spacer()
                    }
                } footer: {
                    Divider()
                        .padding(.vertical)
                }
                Section {
                    ForEach(viewModel.expenses, id: \.item) { exp in
                        DraggableCircle(viewModel: exp)
                    }
                } header: {
                    HStack {
                        Text("This month")
                        Text("$123")
                        Spacer()
                    }
                }
            })
            Spacer()
            HStack {
                Spacer()
                PlusButton(viewModel: viewModel.plusButton)
            }
        }
        .sheet(isPresented: 
                Binding(
                    get: { return viewModel.sheetPresended },
                    set: { (newValue) in return viewModel.sheetPresended = newValue }
                ), content: {
            Text("!!!!")
        })
        .coordinateSpace(name: "screen")
        .padding()
    }
    
}

@Observable
class DashboardViewModel {
    var data: [DraggableCircleViewModel]
    var accounts: [DraggableCircleViewModel]
    var expenses: [DraggableCircleViewModel]
    var plusButton: DraggableCircleViewModel
    var sheetPresended = false
        
    init(data: [DraggableCircleViewModel]) {
        self.data = data
        self.accounts = data.filter { $0.item.type == .account }
        self.expenses = data.filter { $0.item.type == .expense }
        self.plusButton = data.filter { $0.item.type == .plusButton }.first!
        
        for datum in data {
            datum.locationHandler = handleCircle(state:movingItem:)
        }
    }
    
    private func handleCircle(state: CircleState, movingItem: CircleItem) {
        switch state {
        case .idle:
            resetHight()
        case .pressed:
            sheetPresended = true
        case .moving(let location):
            check(offset: location, movingItem: movingItem)
        }
    }
    
    private func check(offset: CGPoint, movingItem: CircleItem) {
        let rect = CGRect(origin: offset, size: CGSize(width: 20, height: 20))
        
        for (index, datum) in data.enumerated() {
            if rect.intersects(datum.rect.wrappedValue) &&
                datum.item.id != movingItem.id {
                if data.filter({ $0.highlighted }).isEmpty {
                    data[index].highlighted = true
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            } else {
                data[index].highlighted = false
            }
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
