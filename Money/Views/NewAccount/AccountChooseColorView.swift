//
//  AccountChooseColorView.swift
//  Money
//
//  Created by Artem on 18.05.2024.
//

import SwiftUI
import DataProvider

struct AccountChooseColorView: View {
    @Binding var account: Account
    @State private var colorsArray = SwiftColor.accountColors
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 50)), count: 6), alignment: .center) {
                ForEach(colorsArray, id: \.self) { color in
                    Circle()
                        .stroke(.gray, lineWidth: account.icon?.color == color ? 3 : 0)
                        .fill(color.value)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                        .onTapGesture {
                            account.icon?.color = color
                        }
                }
            }
            .padding(3)
        }
    }
}

struct SymbolChooseColorView: View {
    @Binding var color: SwiftColor
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(SwiftColor.categoryColors.filter { $0 != .clear }, id: \.self) { color in
                    color.value
                        .clipShape(Circle())
                        .frame(width: 40, height: 40)
                        .opacity(self.color == color ? 1 : 0.3)
                        .onTapGesture {
                            self.color = color
                        }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    let acc = Account(orderIndex: 0,
                      name: "Super Bank",
                      color: SwiftColor.lavender.rawValue,
                      isAccount: true,
                      amount: 999999999)
    AccountChooseColorView(account: .constant(acc))
}
