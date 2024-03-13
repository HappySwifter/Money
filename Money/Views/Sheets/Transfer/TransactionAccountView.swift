//
//  TransactionAccountView.swift
//  Money
//
//  Created by Artem on 09.03.2024.
//

import SwiftUI

struct TransactionAccountView: View {
    
    enum ViewType {
        case source, destination
        
        var title: String {
            switch self {
            case .source:
                return "From"
            case .destination:
                return "To"
            }
        }
    }
    
    let viewType: ViewType
    let item: Transactionable
    let showAmount: Bool
        
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(viewType.title)
                .font(.footnote)
            HStack(spacing: 3) {
                Text("\(item.name)")
                    .lineLimit(1)
                    .font(item.type.isCategory ? .title2 : .title3)
                Text("\(item.icon)")
                    .font(item.type.isCategory ? .largeTitle : .title3)
            }
            .opacity(item.type.isCategory ? 1 : 0.7)
            
            
            if item.type.isAccount {
                HStack(spacing: 3) {
                    Text(item.amount.getString())
                    Text(item.currencySymbol)
                    Spacer()
                }
                .font(.title3)
            }
        }
        .padding()
        .frame(minHeight: 100, maxHeight: 100)
        .background(SwiftColor(rawValue: item.color)?.value.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
