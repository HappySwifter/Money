//
//  CalculatorButtonView.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import SwiftUI

struct CalculatorButtonView: View {
    let size: CGSize
    @State var button: CalculatorButton
    
    var body: some View {
        Text(button.rawValue)
            .font(.title)
            .foregroundColor(.black)
            .frame(minWidth: 0, maxWidth: size.width, minHeight: size.height, maxHeight: size.height)
            .background(button.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 8.0))
    }
}

#Preview {
    CalculatorButtonView(size: CGSize(width: 80, height: 60), button: .but0)
}
