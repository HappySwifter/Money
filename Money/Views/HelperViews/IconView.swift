//
//  IconView.swift
//  Money
//
//  Created by Artem on 09.07.2024.
//

import SwiftUI
import DataProvider

struct IconView: View {
    @ScaledMetric(relativeTo: .largeTitle) var height: CGFloat = 50
    var icon: Icon
    var font = Font.largeTitle
    
    var body: some View {
        Image(systemName: safeSystemImage(icon))
            .frame(height: height)
            .symbolRenderingMode(icon.isMulticolor ? .multicolor : .monochrome)
            .font(font)
            .foregroundStyle(icon.color.value)
            .accessibilityIdentifier(IconViewImage)
            .dynamicTypeSize(.xSmall ... .accessibility3)
    }
    
    private func safeSystemImage(_ icon: Icon) -> String {
        if let _ =  UIImage(systemName: icon.name) {
            return icon.name
        } else if let _ =  UIImage(systemName: icon.removed(modifiers: [.fill])) {
            return icon.removed(modifiers: [.fill])
        } else {
            return icon.removed(modifiers: Icon.Modifiers.allCases)
        }
    }
}

#Preview {
    IconView(icon: Icon(name: "doc", color: .blue, isMulticolor: true), font: .largeTitle)
}
