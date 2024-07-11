//
//  IconView.swift
//  Money
//
//  Created by Artem on 09.07.2024.
//

import SwiftUI

struct IconView: View {
    var icon: Icon
    var font = Font.system(size: 44)
    
    var body: some View {
        Image(systemName: safeSystemImage(icon))
            .symbolRenderingMode(icon.isMulticolor ? .multicolor : .monochrome)
            .font(font)
            .foregroundStyle(icon.color.value)
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
    IconView(icon: Icon(name: "doc", color: .blue, isMulticolor: true))
}
