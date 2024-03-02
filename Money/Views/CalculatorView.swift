//
//  DecimalPadView.swift
//  Money
//
//  Created by Artem on 01.03.2024.
//

import SwiftUI

struct CalculatorView: View {
    let viewModel: CalculatorViewModel
    @Binding var resultString: String
    
    var body: some View {
        LazyVGrid(columns: viewModel.columns, spacing: 0, content: {
            ForEach(viewModel.buttons, id: \.self) { button in
                Button {
                    handlePress(on: button)
                } label: {
                    CalculatorButtonView(size: viewModel.buttonSize, button: button)
                }
            }
        })
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
        .frame(maxWidth: viewModel.buttonSize.width * Double(viewModel.buttonsInColumn))
    }
    
    private func handlePress(on button: CalculatorButton) {
        switch button {
        case .but1, .but2, .but3, .but4, .but5, .but6, .but7, .but8, .but9:
            if resultString == "0" {
                resultString = ""
            }
            resultString.append(button.rawValue)
        case .plus:
            break
        case .minus:
            break
        case .equal:
            break
        case .comma:
            if !resultString.contains(",") {
                resultString.append(button.rawValue)
            }
        case .but0:
            resultString.append(button.rawValue)
        case .remove:
            resultString = String(resultString.dropLast())
            if resultString.isEmpty {
                resultString = "0"
            }
        }
    }
}

class CalculatorViewModel {
    let buttons: [CalculatorButton]
    let buttonsInColumn: Int
    let columns: [GridItem]
    let buttonSize = CGSize(width: 80, height: 50)
    
    init(showCalculator: Bool) {
        self.buttons = CalculatorButton.allCases.filter { showCalculator ? true : !$0.isCalcButton }
        self.buttonsInColumn = showCalculator ? 4 : 3
        self.columns = Array(repeating: GridItem(.fixed(buttonSize.width), spacing: 0), count: self.buttonsInColumn)
    }
    
    
}

#Preview {
    @State var res = "324560"
    return CalculatorView(viewModel: CalculatorViewModel(showCalculator: false), resultString: .constant("0"))
        .background(Color.red.opacity(0.3))
}
