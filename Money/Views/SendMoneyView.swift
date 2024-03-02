//
//  SendMoneyView.swift
//  Money
//
//  Created by Artem on 01.03.2024.
//

import SwiftUI

struct SendMoneyView: View {
    @Binding var isPresented: Bool
    let presentingType: PresentingType

    @State private var amount = "0"
    
    var body: some View {
        VStack {
            switch presentingType {
            case .transfer(let source, let destination):
                HStack {
                    if source?.type == .plusButton {
                        Text("New income")
                    } else {
                        Text(source?.name ?? "")
                    }
                    Text("->")
                    Text(destination?.name ?? "")
                }
            case .details(let item):
                Text("Details: \(item.name)")
            case .addAccount:
                Text("Add new account")
            case .addCategory:
                Text("Add new category")
            case .none:
                Spacer()
            }
            HStack {
                Spacer()
              
                Text(amount)
                    .font(.title)
                    .multilineTextAlignment(.trailing)
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
    SendMoneyView(isPresented: .constant(true), presentingType: .addCategory)
}
