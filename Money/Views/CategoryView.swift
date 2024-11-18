//
//  CategoryView.swift
//  Money
//
//  Created by Artem on 06.03.2024.
//
import SwiftUI
import DataProvider

struct CategoryView: View {
    @Binding var item: Account
    var tapHandler: ((Account) -> Void)?
    var longPressHandler: ((Account) -> Void)?
    
    var body: some View {
        Button(
            action: {
                tapHandler?(item)
            },
            label: {
                VStack(spacing: 2) {
                    
                    IconView(icon: item.icon)
                        .padding(10)
                        .opacity(0.7)

                    Text(item.name.isEmpty ? "Name" : item.name)
                        .font(.body)
                        .lineLimit(1)
                        .dynamicTypeSize(.xLarge ... .xLarge)
                }
//                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            }
        )
        .accessibilityIdentifier(CategoryViewButton)
        .supportsLongPress {
            longPressHandler?(item)
        }
    }
    
}
