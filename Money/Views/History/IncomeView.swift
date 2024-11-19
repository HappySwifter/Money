//
//  IncomeView.swift
//  Money
//
//  Created by Artem on 18.05.2024.
//

import SwiftUI
import DataProvider

struct IncomeView: View {
    let amount: Double
    let account: Account
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                IconView(icon: account.icon, font: .largeTitle)
                Text(account.name)
                    .font(.title3)
                    .foregroundStyle(account.nameColor)
                Spacer()
                Group {
                    Text("+")
                    Text(amount.getString())
                    Text(account.getCurrency()?.symbol ?? "")
                }
                .foregroundStyle(Color.green)
            }
            Text("New income")
                .font(.caption)
                .foregroundStyle(.gray)
        }
    }
}
