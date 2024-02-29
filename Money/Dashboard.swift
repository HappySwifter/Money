//
//  Dashboard.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import Foundation
import SwiftUI

enum DraggableState: Equatable {
    case idle
    case moving(location: CGPoint)
}

struct Dashboard: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var viewModel: DashboardViewModel
    @State private var plusButtonState = DraggableState.idle
    
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
                    ForEach(viewModel.accounts, id: \.name) { acc in
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
                    ForEach(viewModel.expenses, id: \.name) { exp in
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
                PlusButton(plusButtonState: $plusButtonState)
                //            .zIndex(1)
            }
        }
        .onChange(of: plusButtonState, { oldValue, newValue in
            switch newValue {
            case .idle:
                viewModel.resetHight()
            case .moving(let location):
                viewModel.check(offset: location)
            }
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
    
    init(data: [DraggableCircleViewModel]) {
        self.data = data
        self.accounts = data.filter { $0.type == .account }
        self.expenses = data.filter { $0.type == .expense }
        
        for datum in data {
            datum.locationHandler = { [weak self] state in
                switch state {
                case .idle:
                    self?.resetHight()
                case .moving(let location):
                    self?.check(offset: location)
                }
            }
        }
    }
    
    func check(offset: CGPoint) {
        let rect = CGRect(origin: offset, size: CGSize(width: 20, height: 20))
        
        for (index, datum) in data.enumerated() {
            if rect.intersects(datum.rect.wrappedValue) {
                if data.filter({ $0.highlighted }).isEmpty {
                    data[index].highlighted = true
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            } else {
                data[index].highlighted = false
            }
        }
    }
    
    func resetHight() {
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
