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
        
        var alignment: HorizontalAlignment {
            switch self {
            case .source:
                return .leading
            case .destination:
                return .trailing
            }
        }
    }
    
    let viewType: ViewType
    let amount: String
    let item: Transactionable
    let showAmount: Bool
    
    var body: some View {
        VStack(alignment: viewType.alignment) {
            Text(viewType.title)
                .font(.caption)
            
            VStack {
                HStack {
                    Text("\(item.icon)")
                    Text("\(item.name)")
                }
            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(SwiftColor(rawValue: item.color)?.value.opacity(0.3))
            .cornerRadiusWithBorder(radius: 10, borderColor: .gray)
            
            Text(amount)
                .font(.title2)
                .multilineTextAlignment(.trailing)
                .padding(.trailing)
                .opacity(showAmount ? 1 : 0)
        }
    }
}
