//
//  EnterAmountView.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import SwiftUI
import SwiftData

struct TransferMoneyView: View {
//    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Account.date) private var accounts: [Account]
    @Query(sort: \SpendCategory.date) private var categories: [SpendCategory]
    
    @State private var amount = "0"
    @State var source: Transactionable
    @State var destination: Transactionable
    @Binding var isSheetPresented: Bool
    
    
    @State var sourceSheetPresented = false
    @State var destinationSheetPresented = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    sourceSheetPresented.toggle()
                } label: {
                    HStack {
                        Text(source.icon)
                        Text(source.name)
                    }
                    
                }
                Text("-->")
                Button {
                    sourceSheetPresented.toggle()
                } label: {
                    HStack {
                        Text(source.icon)
                        Text(source.name)
                    }
                    
                }
                Spacer()
                Button(" Done ") {
                    makeTransfer()
                    isSheetPresented.toggle()
                }
                .disabled(amount == "0")
                .buttonStyle(DoneButtonStyle())
                
            }

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
        .padding()
        .sheet(isPresented: $sourceSheetPresented) {
            ItemPicker(type: source.type,
                       isPresented: $sourceSheetPresented, 
                       selectedItem: $source)
        }
        .sheet(isPresented: $destinationSheetPresented) {
            ItemPicker(type: destination.type,
                       isPresented: $destinationSheetPresented,
                       selectedItem: $destination)
        }
        
    }
    
    private func makeTransfer() {
        guard let amount = Double(amount) else {
            assert(false)
            return
        }
        source.creadit(amount: amount)
        destination.deposit(amount: amount)
        
    }
}

//#Preview {
//    TransferMoneyView(source: nil,
//        destination: nil,
//                      isSheetPresented: .constant(true))
//}
