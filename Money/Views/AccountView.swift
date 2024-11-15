//
//  DraggableCircle.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import SwiftUI
import DataProvider

struct AccountView: View {
    private let minWidth = 110.0
    @Environment(\.colorScheme) private var colorScheme
    
    @State var item: Account
    @Binding var selected: Bool
    @Binding var presentingType: PresentingType
    
    var backgroundColor: Color {
        colorScheme == .dark ? .white.opacity(0.2) : .white.opacity(0.5)
    }
    
    var body: some View {
        Button(
            action: {
                selected = true
                showImpact()
            },
            label: {
                HStack {
                    VStack(alignment: .leading) {
                        IconView(icon: item.icon, isAccount: item.isAccount)
                            .frame(height: 40)
                        
                        accountName
                        amountView
                    }
                    Spacer()
                }
                .padding()
                .background(backgroundColor)
                .cornerRadiusWithBorder(radius: 20, borderLineWidth: selected ? 1 : 0, borderColor: Color("account_foreground"))
            }
        )
        .accessibilityIdentifier(AccountViewButton)
        .supportsLongPress {
            showImpact()
            presentingType = .details(item: item)
        }
    }
    
    private var accountName: some View {
        Text(item.name.isEmpty ? "Name" : item.name)
            .font(.title2)
            .fontWeight(.light)
            .foregroundStyle(Color("account_foreground"))
        //            .foregroundStyle(Color.black)
            .lineLimit(1)
    }
    
    private var amountView: some View {
        HStack(spacing: 3) {
            Text(prettify(val: item.amount))
                .lineLimit(1)
            Text(item.currency?.symbol ?? "")
        }
        .padding(.vertical, 1)
        .font(.headline)
        .foregroundStyle(Color("account_foreground"))
        //        .foregroundStyle(Color.black)
    }
}

#Preview(body: {
    let icons = ["trash", "banknote", "paperplane", "doc", "clipboard"]
    
    let acc = Account(orderIndex: 0,
                      name: "Bank",
                      color: SwiftColor.lavender.rawValue,
                      isAccount: true,
                      amount: 999,
                      iconName: icons[0],
                      iconColor: SwiftColor.green.rawValue)
    
    let acc2 = Account(orderIndex: 0,
                       name: "Bank",
                       color: SwiftColor.lightSand.rawValue,
                       isAccount: true,
                       amount: 999999999,
                       iconName: icons[1],
                       iconColor: SwiftColor.green.rawValue)
    
    let acc3 = Account(orderIndex: 0,
                       name: "Tinkoff",
                       color: SwiftColor.mintCream.rawValue,
                       isAccount: true,
                       amount: 999,
                       iconName: icons[2],
                       iconColor: SwiftColor.green.rawValue)
    
    var accounts = [Account]()
    accounts.append(acc)
    accounts.append(acc2)
    accounts.append(acc3)
    
    
    //    UserDefaults.standard.setValue(false, forKey: AppSettings.isAccountNameInside)
    
    return ScrollView(.horizontal) {
        HStack {
            ForEach(accounts) { item in
                AccountView(item: item,
                            selected: .constant(true),
                            presentingType: .constant(.none))
                .frame(width: 180)
            }
        }
    }
    .scrollIndicators(.hidden)
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
    .background(Color("gradient_0"))
    
})
