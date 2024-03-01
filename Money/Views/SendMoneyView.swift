//
//  SendMoneyView.swift
//  Money
//
//  Created by Artem on 01.03.2024.
//

import SwiftUI

struct SendMoneyView: View {
    @Binding var amount: String
    @Binding var isPresented: Bool
    
    enum FocusField: Hashable {
      case field
    }
    @FocusState private var focusedField: FocusField?
    
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    isPresented = false
                }, label: {
                    Text("Done")
                        .padding(10)
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                })

            }
            DecimalPadView(resultString: $amount)
        }
        .padding()
        .focused($focusedField, equals: .field)
        .onAppear {
          self.focusedField = .field
        }
        .presentationCornerRadius(30)
        .presentationDetents([.height(380)])
        
    }
}

#Preview {
    SendMoneyView(amount: .constant(""), isPresented: .constant(true))
}
