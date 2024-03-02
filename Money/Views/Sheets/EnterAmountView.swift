//
//  EnterAmountView.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import SwiftUI

struct EnterAmountView: View {
    @State private var amount = "0"
    
    var body: some View {
        HStack {
            Spacer()
            Text(amount)
                .font(.title)
                .multilineTextAlignment(.trailing)
                .padding(.trailing)
        }
        .padding(.bottom)
        CalculatorView(viewModel: CalculatorViewModel(showCalculator: false), resultString: $amount)
        Spacer()
    }
}

#Preview {
    EnterAmountView()
}
