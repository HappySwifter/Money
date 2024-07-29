//
//  CategoryView.swift
//  Money
//
//  Created by Artem on 06.03.2024.
//
import SwiftUI
import DataProvider

struct CategoryView: View {
    @State var item: Account
    var pressHandler: ((Account) -> Void)?
    var longPressHandler: ((Account) -> Void)?
    
    var body: some View {
        Button(
            action: {
                pressHandler?(item)
            },
            label: {
                VStack(spacing: 2) {
                    if let icon = item.icon {
                        IconView(icon: icon)
                            .padding(10)
                            .background(SwiftColor(rawValue: item.color)!.value.opacity(0.3))
                            .clipShape(Circle())
                    } else {
                        // TODO user image
                    }

                    Text(item.name.isEmpty ? "Name" : item.name)
                        .font(.body)
                        .lineLimit(1)
                        .dynamicTypeSize(.xSmall ... .accessibility3)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            }
        )
        .accessibilityIdentifier(CategoryViewButton)
        .supportsLongPress {
            longPressHandler?(item)
        }
    }
    
}
