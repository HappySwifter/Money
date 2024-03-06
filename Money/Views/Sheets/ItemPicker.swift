//
//  ItemPicker.swift
//  Money
//
//  Created by Artem on 06.03.2024.
//

import SwiftUI
import SwiftData

struct ItemPicker: View {
    @Query(sort: \Account.date) private var accounts: [Account]
    @Query(sort: \SpendCategory.date) private var categories: [SpendCategory]
    
    let type: ItemType
    @Binding var isPresented: Bool
    @Binding var selectedItem: Transactionable
    
    
    var body: some View {
        Form {
            switch type {
            case .account:
                ForEach(accounts) { item in
                    HStack {
                        Text(item.icon)
                        Text(item.name)
                    }
                    .onTapGesture {
                        selectedItem = item
                        isPresented.toggle()
                        print("tap")
                    }
                }

            case .category:
                ForEach(categories) { item in
                    Text(item.name)
                }
            }
        }
    }
}
