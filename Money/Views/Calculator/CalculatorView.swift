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
        LazyVGrid(columns: viewModel.columns, spacing: 5, content: {
            ForEach(viewModel.buttons, id: \.self) { button in
                Button {
                    handlePress(on: button)
                } label: {
                    CalculatorButtonView(size: viewModel.buttonSize, button: button)
                }
                .buttonStyle(.plain)
            }
        })
        .padding(7)
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.3))
        .safeAreaPadding(.bottom)
    }
    
    private func handlePress(on button: CalculatorButton) {
        showImpact()
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
            if resultString != "0" {
                resultString.append(button.rawValue)
            }
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
    let buttonSize = CGSize(width: CGFloat.infinity, height: 50)
    
    init(showCalculator: Bool) {
        self.buttons = CalculatorButton.allCases.filter { showCalculator ? true : !$0.isCalcButton }
        self.buttonsInColumn = showCalculator ? 4 : 3
        self.columns = Array(repeating: GridItem(.flexible(), spacing: 5), count: self.buttonsInColumn)
    }
    
    
}

#Preview {
    @State var res = "324560"
    return CalculatorView(viewModel: CalculatorViewModel(showCalculator: false), resultString: .constant("0"))
}
