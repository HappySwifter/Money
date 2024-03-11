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
            HStack(spacing: 3) {
                Text(viewType.title)
                Text("\(item.name)")
                    .lineLimit(1)
                Text("\(item.icon)")
                Spacer()
            }
            .foregroundStyle(Color.gray)
            
            if item.type.isAccount {
                HStack(spacing: 3) {
                    Text(item.amount.getString())
                    Text(item.currencySymbol)
                    Spacer()
                }
                .font(.title)
            }
        }
        .padding()
        .frame(minHeight: 100, maxHeight: 100)
        .background(SwiftColor(rawValue: item.color)?.value.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
