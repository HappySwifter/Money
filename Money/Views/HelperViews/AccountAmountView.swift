//
//  AccountAmountView.swift
//  Money
//
//  Created by Artem on 15.11.2024.
//

import SwiftUI
import DataProvider

struct AccountAmountView: View {
    let account: Account
    
    var body: some View {
        HStack(spacing: 3) {
            Text(prettify(val: account.amount))
                .lineLimit(1)
            Text(account.currencySymbol ?? "")
        }
        .padding(.vertical, 1)
        .font(.headline)
        .foregroundStyle(Constants.blackWhiteColor)
    }
}
