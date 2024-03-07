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
    
    @Query(sort: \Account.date) private var accounts: [Account]
    @Query(sort: \SpendCategory.date) private var categories: [SpendCategory]
    
    @State var selectedAccount: Account?
    @State var createAccountPresented = false
    @State var createCategoryPresented = false
    @State var presentingType = PresentingType.none
    
    var sheetBinding: Binding<Bool> {
        Binding(
            get: { return self.presentingType != .none },
            set: { (newValue) in return self.presentingType = .none }
        )
    }
    
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
        return Array(repeating: .init(.flexible(minimum: 60)), count: count)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Accounts")
                Text("$124.420")
                Spacer()
            }
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(accounts) { item in
                        AccountView(item: item,
                                    selected: Binding(
                                        get: { selectedAccount == item },
                                        set: { _ in selectedAccount = item }),
                                    longPressHandler: itemLongPressHandler(item:))
                    }
                    PlusView(buttonPressed: $createAccountPresented)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
                .padding(.vertical)
            
            HStack {
                Text("This month")
                Text("-$123")
                Spacer()
            }
            
            ScrollView {
                LazyVGrid(columns: columns, alignment: .leading) {
                    ForEach(categories) { item in
                        CategoryView(item: item,
                                     pressHandler: itemPressHandler(item:),
                                     longPressHandler: itemLongPressHandler(item:))
                    }
                    PlusView(buttonPressed: $createCategoryPresented)
                }
            }
        }
        .padding()
        .onChange(of: accounts, initial: true, {
            selectedAccount = accounts.first
        })
        .sheet(isPresented: sheetBinding) { ActionSheetView(
            isPresented: sheetBinding,
            presentingType: presentingType)
        }
        .sheet(isPresented: $createAccountPresented) {
            ActionSheetView(isPresented: $createAccountPresented, presentingType: .addAccount)
        }
        .sheet(isPresented: $createCategoryPresented) {
            ActionSheetView(isPresented: $createCategoryPresented, presentingType: .addCategory)
        }
    }
    
    func itemPressHandler(item: Transactionable) {
        presentingType = .transfer(source: selectedAccount, destination: item)
    }
    
    func itemLongPressHandler(item: Transactionable) {
        presentingType = .details(item: item)
    }
}

#Preview {
    Dashboard()
}
