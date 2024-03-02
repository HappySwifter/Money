//
//  Dashboard.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import Foundation
import SwiftUI
import SwiftData

struct Dashboard: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var viewModel: DashboardViewModel
    @Query(sort: \CircleItem.date) private var items: [CircleItem]
    
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
        return Array(repeating: .init(.flexible(minimum: 60, maximum: 100)), count: count)
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                PlusButton(viewModel: viewModel.plusButton)
            }
            .zIndex(100)
            
            
            if viewModel.showDropableLocations {
                DropableView(viewModel: viewModel.addAccountButton)
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
                DropableView(viewModel: viewModel.addCategoryButton)
            } else {
                HStack {
                    Text("This month")
                    Text("-$123")
                    Spacer()
                }
            }
            
            ScrollView {
                LazyVGrid(columns: columns, alignment: .leading, content: {
                    ForEach(viewModel.categories, id: \.item) { exp in
                        DraggableCircle(viewModel: exp)
                    }
                    .zIndex(-1)
                })
            }
        }
        .coordinateSpace(name: "screen")
        .padding()
        .onAppear {
            viewModel.setModels(from: items)
        }
        .onChange(of: items) { _, _ in
            viewModel.setModels(from: items)
        }
        .sheet(isPresented: viewModel.sheetBinding) { ActionSheetView(
            isPresented: viewModel.sheetBinding,
            presentingType: viewModel.presentingType)
        }
    }
}

@Observable
class DashboardViewModel {
    private var allModels = [DraggableCircleViewModel]()
    var accounts = [DraggableCircleViewModel]()
    var categories = [DraggableCircleViewModel]()
    
    let plusButton = DraggableCircleViewModel(
        item: CircleItem(name: "", type: .plusButton))
    let addAccountButton = DraggableCircleViewModel(
        item: CircleItem(name: "", type: .addAccount))
    let addCategoryButton = DraggableCircleViewModel(
        item: CircleItem(name: "", type: .addCategory))
    
    var showDropableLocations = false
    var presentingType = PresentingType.none
    
    var sheetBinding: Binding<Bool> {
        Binding(
            get: { return self.presentingType != .none },
            set: { (newValue) in return self.presentingType = .none }
        )
    }
//    @ObservationIgnored
    private let movingItemSize = CGSize(width: 1, height: 1)
    private let plusButtonOffsetThreshold = 20.0
    private let animation = Animation.smooth(duration: 0.3)
    
    init() {
        update()
    }

    func update() {
        self.allModels = accounts + categories + [plusButton, addAccountButton, addCategoryButton]
        for datum in allModels {
            datum.locationHandler = handle(movingItem:state:)
        }
    }
    
    func setModels(from items: [CircleItem]) {
        accounts = items
            .filter { $0.type == .account }
            .prefix(4)
            .map { DraggableCircleViewModel(item: $0) }
        categories = items
            .filter { $0.type == .category }
            .map { DraggableCircleViewModel(item: $0) }
        update()
    }
    
    private func handle(movingItem: CircleItem, state: DraggableCircleState) {
        
        switch state {
        case .released(let location):
            resetHight()
            showImpact()
            if let destination = shouldPresentSheet(movingItem: movingItem, location: location) {
                if destination.type == .addAccount {
                    presentingType = .addAccount
                } else if destination.type == .addCategory {
                    presentingType = .addCategory
                } else {
                    presentingType = .transfer(source: movingItem,
                                               destination: destination)
                }
            }
            updateDropableLocations(plusButtonOffset: .zero)
        case .pressed:
            if movingItem.type == .plusButton {
                presentingType = .transfer(source: nil,
                                           destination: nil)
            } else {
                presentingType = .details(item: movingItem)
            }
        case .moving(let location, let offset):
            if offset == .zero { showImpact() }
            
            if movingItem.type == .plusButton {
                updateDropableLocations(plusButtonOffset: offset)
            }
            highlighted(location: location, movingItem: movingItem)
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
        
        for (index, datum) in allModels.enumerated() {
            if rect.intersects(datum.initialRect) {
                if datum.item != movingItem &&
                    movingItem.type.canTrigger(stillItem: datum.item) &&
                    allModels.filter({ $0.stillState == .focused }).isEmpty {
                    allModels[index].setFocus()
                    showImpact()
                }
            } else {
                allModels[index].unFocus()
            }
        }
    }
    
    private func shouldPresentSheet(movingItem: CircleItem, location: CGPoint) -> CircleItem? {
        let rect = CGRect(origin: location, size: movingItemSize)
        let intersectedModel = allModels
            .filter { rect.intersects($0.initialRect) }
            .filter { movingItem.type.canTrigger(stillItem: $0.item) }
            .first
        if let interspectedModel = intersectedModel,
           interspectedModel.item != movingItem {
            return interspectedModel.item
        } else {
            return nil
        }
    }
    
    private func resetHight() {
        allModels.forEach { $0.unFocus() }
    }
}

#Preview {
    Dashboard(viewModel: DashboardViewModel())
}
