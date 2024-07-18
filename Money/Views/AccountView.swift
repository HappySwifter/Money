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
                VStack {
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
            .dynamicTypeSize(.xSmall ... .accessibility1)
            .font(.subheadline)
            .foregroundStyle(Color.gray)
            .lineLimit(1)
            .frame(width: max(scaledMetric, minWidth))
    }
}
