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
        Image(systemName: safeSystemImage(icon.name, isFill: icon.isFill))
            .symbolRenderingMode(icon.isMulticolor ? .multicolor : .monochrome)
            .font(font)
            .foregroundStyle(icon.color.value)
    }
    
    private func safeSystemImage(_ systemName: String, isFill: Bool) -> String {
        let image = systemName + (isFill ? ".fill" : "")
        return UIImage(systemName: image) != nil ? image : systemName
    }
}

#Preview {
    IconView(icon: Icon(name: "doc", color: .blue, isFill: true, isMulticolor: true))
}
