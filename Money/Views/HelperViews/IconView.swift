//
//  IconView.swift
//  Money
//
//  Created by Artem on 09.07.2024.
//

import SwiftUI
import DataProvider

struct IconView: View {
    var icon: Icon
    var isAccount = false
    var font = Font.largeTitle
    
    var body: some View {
        Image(systemName: safeSystemImage(icon))
            .symbolRenderingMode(.monochrome)
            .font(font)
            .foregroundStyle(isAccount ? Color("account_foreground") : icon.color.colorWithOpacity)
            .accessibilityIdentifier(IconViewImage)
            .dynamicTypeSize(.xSmall ... .accessibility3)
    }
    
    private func safeSystemImage(_ icon: Icon) -> String {
        if let _ = UIImage(systemName: icon.name) {
            return icon.name
        } else if let _ = UIImage(systemName: icon.removed(modifiers: [.fill])) {
            return icon.removed(modifiers: [.fill])
        } else {
            return icon.removed(modifiers: Icon.Modifiers.allCases)
        }
    }
}

#Preview {
    IconView(icon: Icon(name: "doc", color: .blue),
             isAccount: true,
             font: .largeTitle)
}
