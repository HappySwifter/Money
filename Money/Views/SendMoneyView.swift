//
//  SendMoneyView.swift
//  Money
//
//  Created by Artem on 01.03.2024.
//

import SwiftUI

struct SendMoneyView: View {
    @Binding var amount: String
    enum FocusField: Hashable {
      case field
    }
    @FocusState private var focusedField: FocusField?
    
    
    var body: some View {
        TextField("How much?", text: $amount)
            .focused($focusedField, equals: .field)
            .onAppear {
              self.focusedField = .field
          }
    }
}

#Preview {
    SendMoneyView(amount: .constant(""))
}
