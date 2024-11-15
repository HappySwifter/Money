//
//  AccountChooseColorView.swift
//  Money
//
//  Created by Artem on 18.05.2024.
//

import SwiftUI
import DataProvider

struct ChooseColorView: View {
    @Binding var account: Account
    private var colorsArray: [SwiftColor] {
        if account.isAccount {
            return SwiftColor.accountColors
        } else {
            return SwiftColor.categoryColors
        }
    }
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 50)), count: 6), alignment: .center) {
            ForEach(colorsArray, id: \.self) { color in
                Circle()
                    .stroke(.gray, lineWidth: account.icon.color == color ? 3 : 0)
                    .fill(color.value)
                    .opacity(0.6)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    .onTapGesture {
                        account.icon.color = color
                    }
            }
        }
        .padding(3)
    }
}

#Preview {
    let acc = Account(orderIndex: 0,
                      name: "Super Bank",
                      color: SwiftColor.lavender.rawValue,
                      isAccount: true,
                      amount: 999999999,
                      iconName: "banknote.fill",
                      iconColor: SwiftColor.green.rawValue)
    ChooseColorView(account: .constant(acc))
}
