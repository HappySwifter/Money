//
//  SpengingView.swift
//  Money
//
//  Created by Artem on 18.05.2024.
//

import SwiftUI
import DataProvider

struct SpengingView: View {
    let transaction: MyTransaction
    let source: Account
    let destination: Account
    
    var body: some View {
        HStack {
            if let icon = destination.icon {
                IconView(icon: icon, font: .largeTitle)
            }
            Text(destination.name)
                .font(.title3)
                .foregroundStyle(destination.nameColor)
            Spacer()
            Text(source.name)
                .foregroundStyle(source.nameColor)
            Text("- \(transaction.sourceAmount.getString()) \(source.currency?.symbol ?? "")")
                .font(.title3)
        }
    }
}
