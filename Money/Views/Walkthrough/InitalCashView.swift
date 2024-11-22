//
//  InitalCashView.swift
//  Money
//
//  Created by Artem on 21.11.2024.
//

import SwiftUI
import DataProvider

struct InitalCashView: View {
    @Environment(\.dataHandlerWithMainContext) private var dataHandler

    let currency: AccountCurrency
   
    @State private var value = "0"
    @State private var isNextScreenPresented = false
    private let account = Account(orderIndex: 0,
                                  name: "Cash",
                                  color: "",
                                  isAccount: true,
                                  amount: 0,
                                  iconName: "banknote.fill",
                                  iconColor: SwiftColor.mintCream.rawValue)
    
    var body: some View {
        VStack {
            Text("Set up your cash balance")
                .fontWeight(.bold)
                .font(.title2)
                .padding(.vertical)
            Text("How much you do you have in your wallet")
                .font(.footnote)
                .padding(.bottom)
                
            EnterAmountView(symbol: currency.symbol,
                            isFocused: true, value: $value,
                            useTextField: true)

            Spacer()
            
            Button {
                saveCurrency()
                saveAccount()
                isNextScreenPresented.toggle()
            } label: {
                Text("Next")
            }
            .navigationDestination(isPresented: $isNextScreenPresented) {
                EnableFaceIdView()
            }
            .buttonStyle(StretchedRoundedButtonStyle(
                enabledColor: .green,
                disabledColor: .gray)
            )
        }
        .padding()
    }
    
    private func saveCurrency() {
        let cur = MyCurrency(name: currency.name, rateToBaseCurrency: 0, isBase: true)
        Task {
            await dataHandler?.new(currency: cur)
        }
    }
    
    private func saveAccount() {
        account.setInitial(amount: value)
        account.set(currency: currency)
        Task {
            await dataHandler?.new(account: account)
        }
    }
}
