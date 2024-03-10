//
//  ExchangeRateView.swift
//  Money
//
//  Created by Artem on 10.03.2024.
//

import SwiftUI

struct ExchangeRateView: View {
    
    @State private var exchangeRate: Double?
    @State private var sourceAmount = 0.0
    @State private var destinationAmount = "0"
    
    enum FocusField: Hashable {
      case field
    }
    @FocusState private var focusedField: FocusField?
    
    
    var body: some View {
        
        TextField("0", text: $destinationAmount)
            .font(.title2)
            .multilineTextAlignment(.trailing)
            .keyboardType(.decimalPad)
            .focused($focusedField, equals: .field)
            .onAppear {
                self.focusedField = .field
            }
    }
}

#Preview {
    ExchangeRateView()
}
