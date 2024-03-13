//
//  CategoryView.swift
//  Money
//
//  Created by Artem on 06.03.2024.
//
import SwiftUI

struct CategoryView: View {
    @State var item: SpendCategory
    var pressHandler: ((Transactionable) -> ())
    var longPressHandler: ((Transactionable) -> ())
    
    var body: some View {
        Button(
            action: {
                pressHandler(item)
            },
            label: {
                VStack {
                    Text(item.icon)
                        .font(.system(size: 35))
                    Text(item.name.isEmpty ? "Name" : item.name)
                        .font(.subheadline)
//                        .foregroundStyle(Color.gray)
                }
                .padding(10)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                .background(SwiftColor(rawValue: item.color)!.value.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        )
        .supportsLongPress {
            longPressHandler(item)
        }
    }
    
}
