//
//  Dashboard.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import Foundation
import SwiftUI

enum PlusButtonState: Equatable {
    case idle
    case moving(location: CGPoint)
}

struct Dashboard: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var viewModel: DashboardViewModel
    
    @State private var plusButtonState = PlusButtonState.idle

    
    let data = (1...10).map { "Item \($0)" }

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
                resetHight()
            case .moving(let location):
                check(offset: location)
            }
        })
        .coordinateSpace(name: "screen")
        .padding()
    }
        
    
    private func resetHight() {
        for i in 0..<viewModel.accounts.count {
            viewModel.accounts[i].highlighted = false
        }
        for i in 0..<viewModel.expenses.count {
            viewModel.expenses[i].highlighted = false
        }
    }
    
    func check(offset: CGPoint) {
        let rect = CGRect(origin: offset, size: CGSize(width: 20, height: 20))
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
        
        for (index, expense) in viewModel.expenses.enumerated() {
            if rect.intersects(expense.origin.wrappedValue) {
                if viewModel.expenses[index].highlighted == false {
                    resetHight()
                    viewModel.expenses[index].highlighted = true
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            } else {
                viewModel.expenses[index].highlighted = false
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
    var expenses: [DraggableCircleViewModel]
    
    init(accounts: [DraggableCircleViewModel], expenses: [DraggableCircleViewModel]) {
        self.accounts = accounts
        self.expenses = expenses
    }
}


#Preview {
    Dashboard(viewModel: DashboardViewModel(accounts: MockData.accounts, expenses: MockData.expenses))
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
