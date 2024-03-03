//
//  AccountDetailsView.swift
//  Money
//
//  Created by Artem on 03.03.2024.
//

import SwiftUI

struct AccountDetailsView: View {
    let item: CircleItem
    var body: some View {
        Text("Details: \(item.name)")
    }
}

#Preview {
    AccountDetailsView(item: CircleItem(name: "test", type: .account))
}
