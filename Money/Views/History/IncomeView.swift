//
//  IncomeView.swift
//  Money
//
//  Created by Artem on 18.05.2024.
//

import SwiftUI
import DataProvider

struct IncomeView: View {
    let amount: String
    let account: Account
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let icon = account.icon {
                    IconView(icon: icon, font: .largeTitle)
                }
                Text(account.name)
                    .font(.title3)
                    .foregroundStyle(account.hid ? Color.gray : Color.black)
                Spacer()
                Group {
                    Text("+")
                    Text(amount)
                    Text(account.currency?.symbol ?? "")
                }
                .foregroundStyle(Color.green)
            }
            Text("New income")
                .font(.caption)
                .foregroundStyle(.gray)
        }
    }
}
