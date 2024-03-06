//
//  DraggableCircle.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import SwiftUI

struct AccountView: View {
    @State var item: Account
    var pressHandler: ((Transactionable) -> ())?
    var longPressHandler: ((Transactionable) -> ())?
    
    var body: some View {
        Button(
            action: {
                pressHandler?(item)
            },
            label: {
                VStack {
                    VStack {
                        Text(item.icon)
                            .font(.system(size: 45))
                        Text(item.name.isEmpty ? "Name" : item.name)
                            .font(.title3)
                            .foregroundStyle(Color.gray)
                        if item.type == .account {
                            Text(prettify(val: item.amount))
                        }
                    }
                    .padding(10)
                }
                .frame(width: 100, height: 120)
                .background(SwiftColor(rawValue: item.color)!.value.opacity(0.2))
                .clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
            }
        )
        .supportsLongPress {
            longPressHandler?(item)
        }
        
        
        
    }

}
