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
            .foregroundColor(.white)
            .frame(width: size.width, height: size.height)
            .background(button.backgroundColor)
            .border(Color.black, width: 0.5)
    }
}

#Preview {
    CalculatorButtonView(size: CGSize(width: 80, height: 60), button: .but0)
}
