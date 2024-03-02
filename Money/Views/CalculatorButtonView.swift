//
//  CalculatorButtonView.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import SwiftUI

struct CalculatorButtonView: View {
    @State var button: CalculatorButtons
    var body: some View {
        Text(button.rawValue)
            .frame(width: 40, height: 40, alignment: .center)
            .padding(10)
            .font(.title)
            .foregroundColor(.white)
            .background(button.backgroundColor)
            .border(Color.black, width: 0.5)
    }
}

#Preview {
    CalculatorButtonView(button: .but0)
}
