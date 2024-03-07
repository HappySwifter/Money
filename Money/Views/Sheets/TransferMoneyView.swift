//
//  EnterAmountView.swift
//  Money
//
//  Created by Artem on 02.03.2024.
//

import SwiftUI
import SwiftData

struct TransferMoneyView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Account.date) private var accounts: [Account]
    @Query(sort: \SpendCategory.date) private var categories: [SpendCategory]
    
    @State private var amount = "0"
    @State var source: Transactionable
    @State var destination: Transactionable
    @Binding var isSheetPresented: Bool
    
    
//    @State var sourceSheetPresented = false
//    @State var destinationSheetPresented = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                HStack {
                    
                    Menu("\(source.icon) \(source.name)") {
                        switch source.type {
                        case .account:
                            ForEach(accounts) { acc in
                                Button {
                                    source = acc
                                } label: {
                                    HStack {
                                        Text("\(acc.icon) \(acc.name)")
                                        Spacer()
                                        if source.name == acc.name {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        case .category:
                            Color.clear
                        }
                    }

                    Text("-->")
                    
                    Menu("\(destination.icon) \(destination.name)") {
                        switch destination.type {
                        case .account:
                            Text("Accounts")
                            ForEach(accounts) { acc in
                                Button {
                                    destination = acc
                                } label: {
                                    HStack {
                                        Text("\(acc.icon) \(acc.name)")
                                        Spacer()
                                        if destination.name == acc.name && destination.type.isSameType(with: acc.type) {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                            
                            Divider()
                            Text("Categories")
                            ForEach(categories) { cat in
                                Button {
                                    destination = cat
                                } label: {
                                    HStack {
                                        Text("\(cat.icon) \(cat.name)")
                                        Spacer()
                                        if destination.name == cat.name && destination.type.isSameType(with: cat.type) {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        case .category:
                            Text("Categories")
                            ForEach(categories) { cat in
                                Button {
                                    destination = cat
                                } label: {
                                    HStack {
                                        Text("\(cat.icon) \(cat.name)")
                                        Spacer()
                                        if destination.name == cat.name && destination.type.isSameType(with: cat.type) {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                            
                            Divider()
                            Text("Accounts")
                            ForEach(accounts) { acc in
                                Button {
                                    destination = acc
                                } label: {
                                    HStack {
                                        Text("\(acc.icon) \(acc.name)")
                                        Spacer()
                                        if destination.name == acc.name && destination.type.isSameType(with: acc.type) {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .environment(\.menuOrder, .fixed)
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
//            .sheet(isPresented: $sourceSheetPresented) {
//                ItemPicker(type: source.type,
//                           isPresented: $sourceSheetPresented,
//                           selectedItem: $source)
//            }
//            .sheet(isPresented: $destinationSheetPresented) {
//                ItemPicker(type: destination.type,
//                           isPresented: $destinationSheetPresented,
//                           selectedItem: $destination)
//            }
            .navigationTitle(destination.type.isAccount ? "New transaction" : "New expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(" Done ") {
                        makeTransfer()
                        isSheetPresented.toggle()
                    }
                    .disabled(amount == "0")
                    .buttonStyle(DoneButtonStyle())
                }
            }
        }
    }
    
    private func makeTransfer() {
        guard let amount = Double(amount) else {
            assert(false)
            return
        }
        source.credit(amount: amount, to: destination)
        destination.deposit(amount: amount, from: source)
        
        let transaction = Transaction(amount: amount,
                                      sourceId: source.id,
                                      destination: destination.type)
        modelContext.insert(transaction)
    }
}

//#Preview {
//    TransferMoneyView(source: nil,
//        destination: nil,
//                      isSheetPresented: .constant(true))
//}
