//
//  DraggableCircle.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import SwiftUI

struct AccountView: View {
    @State var item: Account
    @Binding var selected: Bool
    var longPressHandler: ((Transactionable) -> ())?
    
    var body: some View {
        Button(
            action: {
                selected = true
            },
            label: {
                VStack {
                    VStack {
                        Text(item.icon)
                            .font(.system(size: 45))
                        Text(item.name.isEmpty ? "Name" : item.name)
                            .font(.subheadline)
                            .foregroundStyle(Color.gray)
                        if item.type.isAccount {
                            HStack(spacing: 3) {
                                Text(item.currencySymbol)
                                Text(prettify(val: item.amount, code: item.currencyCode))
                            
                            }
                            .font(.caption2)
                        }
                    }
                    .padding(10)
                }
                .frame(width: 100, height: 120)
                .background(SwiftColor(rawValue: item.color)!.value.opacity(0.2))
                .cornerRadiusWithBorder(radius: 20, borderLineWidth: selected ? 3 : 0, borderColor: .cyan)
            }
        )
        .supportsLongPress {
            longPressHandler?(item)
        }
    }
}
