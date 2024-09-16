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
    @AppStorage(AppSettings.isAccountNameInside) var isAccountNameInside: Bool = true

    @State var item: Account
    let currencySymbol: String?
    @Binding var selected: Bool
    @Binding var presentingType: PresentingType
    
    var body: some View {
        Button(
            action: {
                selected = true
                showImpact()
            },
            label: {
                VStack(spacing: 5) {
                    VStack {
                        VStack {
                            if let icon = item.icon {
                                IconView(icon: icon, isAccount: item.isAccount)
                                    .frame(height: 40)
                                    .padding(.bottom, 2)
//                                    .padding(.horizontal)
//                                    .background(Color.red.opacity(0.5))
                            } else {
                                // TODO user image
                            }
                            accountName
                            
                            if isAccountNameInside {
                                amountView
                            }
                        }
                        .padding(10)
                    }
                    .frame(width: 150)
                    .background(SwiftColor(rawValue: item.color)!.value)
                    .cornerRadiusWithBorder(radius: 20, borderLineWidth: selected ? 3 : 0, borderColor: .black)
                    
                    if !isAccountNameInside {
                        amountView
                    }
                }
                .frame(width:150)
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
            .dynamicTypeSize(.xSmall ... .accessibility3)
            .font(.title3)
            .foregroundStyle(Color("account_foreground"))
            .lineLimit(1)
            .frame(width: 150)
            .padding(.bottom, 2)
            .padding(.horizontal, 2)
    }
    
    private var amountView: some View {
        HStack(spacing: 3) {
            Text(prettify(val: item.amount))
                .lineLimit(1)
            Text(currencySymbol ?? "")
        }
        .padding(.vertical, 5)
        .font(.title3)
        .foregroundStyle(Color("account_foreground"))
        .dynamicTypeSize(.xSmall ... .accessibility3)
    }
}

#Preview(body: {
    let icons = ["trash", "banknote", "paperplane", "doc", "clipboard"]

    let acc = Account(orderIndex: 0,
                      name: "Super Bank",
                      color: SwiftColor.lavender.rawValue,
                      isAccount: true,
                      amount: 999999999)
    acc.icon = Icon(name: icons[0], color: .green)
    
    let acc2 = Account(orderIndex: 0,
                       name: "Bank",
                       color: SwiftColor.lightSand.rawValue,
                       isAccount: true,
                       amount: 999999999)
    acc2.icon = Icon(name: icons[1], color: .green)
    
    let acc3 = Account(orderIndex: 0,
                       name: "Tinkoff",
                       color: SwiftColor.mintCream.rawValue,
                       isAccount: true,
                       amount: 999)
    acc3.icon = Icon(name: icons[2], color: .green)
        
    var accounts = [Account]()
    accounts.append(acc)
    accounts.append(acc2)
    accounts.append(acc3)
    

    UserDefaults.standard.setValue(false, forKey: AppSettings.isAccountNameInside)
    
    return ScrollView(.horizontal) {
        HStack {
            ForEach(accounts) { item in
                AccountView(item: item,
                            currencySymbol: item.currency?.symbol,
                            selected: .constant(true),
                            presentingType: .constant(.none))
            }
        }
    }
    .scrollIndicators(.hidden)
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
})
