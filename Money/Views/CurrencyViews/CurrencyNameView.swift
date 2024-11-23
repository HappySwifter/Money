//
//  CurrencyNameView.swift
//  Money
//
//  Created by Artem on 23.11.2024.
//

import SwiftUI
import DataProvider

struct CurrencyNameView: View {
    let currency: CurrencyStruct?
    
    var body: some View {
        HStack {
            if let currency {
                Text(currency.code.uppercased())
                    .fontWeight(.bold)
                Text("- \(currency.name)")
            } else {
                Text("Select currency")
            }
            Spacer()
            Image(systemName: "chevron.down")
        }
        .padding()
        .background(Color("black_background"))
        .cornerRadiusWithBorder(radius: Constants.fieldCornerRadius)
    }
}
