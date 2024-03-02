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
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                HStack {
                    TextField("Enter amount", text: $amount)
                        .font(.title)
                        .disabled(true)
                        .multilineTextAlignment(.trailing)
                }
                .padding(.trailing)
                Button(action: {
                    isPresented = false
                }, label: {
                    Text("Done")
                        .padding(15)
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                })
            }
            .padding(.bottom)
            CalculatorView(viewModel: CalculatorViewModel(showCalculator: false), resultString: $amount)
            Spacer()
        }
        .padding()
        .presentationCornerRadius(30)
        .presentationDetents([.height(380)])
        
    }
}

#Preview {
    SendMoneyView(amount: .constant(""), isPresented: .constant(true))
}
