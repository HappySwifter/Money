//
//  DraggableCircle.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import SwiftUI

struct AccountView: View {
    @Environment(SettingsService.self) private var settings
    @State var item: Account
    @Binding var currency: MyCurrency?
    @Binding var selected: Bool
    var longPressHandler: ((Account) -> ())?
    
    var body: some View {
        Button(
            action: {
                selected = true
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
                                Text(item.name.isEmpty ? "Name" : item.name)
                                    .font(.subheadline)
                                    .foregroundStyle(Color.gray)
                            }
                            HStack(spacing: 3) {
                                Text(prettify(val: item.amount))
                                Text(currency?.symbol ?? "")
                            }
                            .font(.caption2)
                        }
                        .padding(10)
                    }
                    .frame(width: 100, height: 120)
                    .background(SwiftColor(rawValue: item.color)!.value.opacity(0.2))
                    .cornerRadiusWithBorder(radius: 20, borderLineWidth: selected ? 3 : 0, borderColor: .cyan)
                    
                    if !settings.appSettings.isAccountNameInside {
                        Text(item.name.isEmpty ? "Name" : item.name)
                            .font(.subheadline)
                            .foregroundStyle(Color.gray)
                    }
                }
                
            }
        )
        .accessibilityIdentifier("_AccountView_Button")
        .supportsLongPress {
            longPressHandler?(item)
        }
    }
}
