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
//        
//        var alignment: HorizontalAlignment {
//            switch self {
//            case .source:
//                return .leading
//            case .destination:
//                return .trailing
//            }
//        }
    }
    
    let viewType: ViewType
    let amount: String
    let item: Transactionable
    let showAmount: Bool
    
    //    @State var temp = ""
    
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
                    Text(prettify(val: item.amount, fractionLength: 2))
                    Text(item.currencySymbol)
                    Spacer()
                }
                .font(.title)
            }
        }
        .padding()
        .background(SwiftColor(rawValue: item.color)?.value.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
