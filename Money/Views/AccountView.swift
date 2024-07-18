//
//  DraggableCircle.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import SwiftUI

struct AccountView: View {
    private let minWidth = 110.0
    @ScaledMetric private var scaledMetric: CGFloat = 100
    
    @Environment(SettingsService.self) private var settings
    @State var item: Account
    @Binding var currency: MyCurrency?
    @Binding var selected: Bool
    var longPressHandler: ((Account) -> ())?
    
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
                                IconView(icon: icon)
                            } else {
                                // TODO user image
                            }
                            if settings.appSettings.isAccountNameInside {
                                accountName
                            }
                            HStack(spacing: 3) {
                                Text(prettify(val: item.amount))
                                    .lineLimit(1)
                                Text(currency?.symbol ?? "")
                            }
                            .font(.caption2)
                            .dynamicTypeSize(.xSmall ... .accessibility3)
                        }
                        .padding(10)
                    }
                    .frame(width: max(scaledMetric, minWidth))
                    .background(SwiftColor(rawValue: item.color)!.value.opacity(0.2))
                    .cornerRadiusWithBorder(radius: 20, borderLineWidth: selected ? 3 : 0, borderColor: .cyan)
                    
                    if !settings.appSettings.isAccountNameInside {
                        accountName
                            .frame(width: max(scaledMetric, minWidth))
                    }
                }
                
            }
        )
        .accessibilityIdentifier(AccountViewButton)
        .supportsLongPress {
            longPressHandler?(item)
        }
    }
    
    private var accountName: some View {
        Text(item.name.isEmpty ? "Name" : item.name)
            .dynamicTypeSize(.xSmall ... .accessibility3)
            .font(.subheadline)
            .foregroundStyle(Color.gray)
            .lineLimit(1)
            .frame(width: max(scaledMetric, minWidth))
    }
}

#Preview(body: {
    let icons = ["trash", "banknote", "paperplane", "doc", "clipboard"]

    var acc = Account(orderIndex: 0, name: "Super Bank", color: SwiftColor.blue, isAccount: true, amount: 999999999)
    acc.icon = Icon(name: icons[0], color: .green, isMulticolor: true)
    
    var acc2 = Account(orderIndex: 0, name: "Bank", color: SwiftColor.blue, isAccount: true, amount: 999999999)
    acc2.icon = Icon(name: icons[1], color: .green, isMulticolor: true)
    
    var acc3 = Account(orderIndex: 0, name: "Tinkoff", color: SwiftColor.blue, isAccount: true, amount: 999)
    acc3.icon = Icon(name: icons[2], color: .green, isMulticolor: true)
        
    var accounts = [Account]()
    accounts.append(acc)
    accounts.append(acc2)
    accounts.append(acc3)
    
    let set = SettingsService()
    set.save(settings: AppSettings(isAccountNameInside: false))

    return ScrollView(.horizontal) {
        HStack {
            ForEach(accounts) { item in
                AccountView(item: item,
                            currency: .constant(item.currency),
                            selected: .constant(false),
                            longPressHandler: nil)
                .environment(set)
            }
        }
    }
    .scrollIndicators(.hidden)
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
})
