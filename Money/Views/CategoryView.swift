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
    var selectedAccount: Account?
    @Binding var presentingType: PresentingType
    
    var body: some View {
        Button(
            action: {
                if let selectedAccount {
                    showImpact()
                    presentingType = .transfer(source: selectedAccount, destination: item)
                }
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
            showImpact()
            presentingType = .details(item: item)
        }
    }
    
}
