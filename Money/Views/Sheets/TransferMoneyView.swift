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
    @Query(sort: \CircleItem.date) private var items: [CircleItem]

    @State private var amount = "0"
    @State var source: CircleItem
    @State var destination: CircleItem
    @Binding var isSheetPresented: Bool
    
    
    
    
    var body: some View {
        VStack {
            HStack {
                Picker("", selection: $source) {
                    ForEach(items.filter { $0.type == source.type }) { account in
                        Text("\(account.icon) \(account.name)")
                            .font(.title)
                            .tag(account)
                    }
                }
                Text("-->")
                Picker("", selection: $destination) {
                    ForEach(items.filter { $0.type == destination.type }) { account in
                        Text("\(account.icon) \(account.name)")
                        .tag(account)
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
    }
    
    private func makeTransfer() {
        guard let amount = Double(amount) else {
            assert(false)
            return
        }
        source.amount = source.amount - amount
        destination.amount = source.amount + amount
        
    }
}

//#Preview {
//    TransferMoneyView(source: nil,
//        destination: nil,
//                      isSheetPresented: .constant(true))
//}
