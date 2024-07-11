//
//  CategoryView.swift
//  Money
//
//  Created by Artem on 06.03.2024.
//
import SwiftUI

struct CategoryView: View {
    @State var item: Account
    var pressHandler: ((Account) -> ())
    var longPressHandler: ((Account) -> ())
    
    var body: some View {
        Button(
            action: {
                pressHandler(item)
            },
            label: {
                VStack(spacing: 2) {
                    if let icon = item.icon {
                        IconView(icon: icon)
                            .padding(15)
                            .background(SwiftColor(rawValue: item.color)!.value.opacity(0.3))
                            .clipShape(Circle())
                    } else {
                        // TODO user image
                    }

                    Text(item.name.isEmpty ? "Name" : item.name)
                        .font(.body)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 100)
            }
        )
        .supportsLongPress {
            longPressHandler(item)
        }
    }
    
}
