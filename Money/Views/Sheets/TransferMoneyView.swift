//
//  EnterAmountView.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import SwiftUI
import SwiftData

struct TransferMoneyView: View {
    @State private var amount = "0"
    @State var source: CircleItem
    @State var destination: CircleItem
    @Binding var isSheetPresented: Bool
    
    @Query(sort: \CircleItem.date) private var items: [CircleItem]
    
    
    
    var body: some View {

        
        VStack {
            Spacer()
            HStack {
                Picker("", selection: $source) {
                    ForEach(items.filter { $0.type == source.type }) { account in
                        Text("\(account.icon) \(account.name)")
                            .font(.title3)
                            .tag(account)
                    }
                }
                .pickerStyle(.wheel)
                
                Text("-->")
                
                Picker("", selection: $destination) {
                    ForEach(items.filter { $0.type == source.type }) { account in
                        Text("\(account.icon) \(account.name)")
                            .font(.title3)
                            .tag(account)
                    }
                }
                .pickerStyle(.wheel)
            }
            .frame(height: 100, alignment: .center)
            .padding()
            
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
    }
}

//#Preview {
//    TransferMoneyView(source: nil,
//        destination: nil,
//                      isSheetPresented: .constant(true))
//}
