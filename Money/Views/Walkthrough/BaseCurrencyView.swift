//
//  AddDataHelperView.swift
//  Money
//
//  Created by Artem on 11.07.2024.
//

import SwiftUI
import DataProvider
import OSLog

@MainActor
struct BaseCurrencyView: View {
    @Environment(Preferences.self) private var preferences

    private let logger = Logger(
        subsystem: "Money",
        category: "AddDataHelperView"
    )
    @State var currency: CurrencyStruct?
    @State var isCurrencySelectorPresented = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackGradientView()
                
                VStack(alignment: .center) {
                    Text("Select base currency")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.vertical)
                    Text("Start by selecting your base currency")
                        .font(.footnote)
                        .padding(.bottom)
                    
                    CurrencyNameView(currency: currency)
                    .onTapGesture {
                        isCurrencySelectorPresented.toggle()
                    }
                    
                    Spacer()

                    NavigationLink {
                        if let currency {
                            InitalCashView(currency: currency)
                        }
                    } label: {
                        Text("Next")
                    }
                    .disabled(currency == nil)
                    .buttonStyle(StretchedRoundedButtonStyle(
                        enabledColor: .green,
                        disabledColor: .gray)
                    )
                }
                .padding()
            }
        }
        .onAppear {
            currency = preferences.getUserLocalCurrency()
        }
        .popover(isPresented: $isCurrencySelectorPresented) {
            NavigationStack {
                CurrencyPicker(initiallySelectedCurrency: currency) { selected in
                    currency = selected
                }
            }
        }
    }
}

#Preview {

    @Previewable @State var currenciesManager = CurrenciesManager()
    print(currenciesManager.currencies.count)
    
    return BaseCurrencyView()
        .environment(Preferences(currenciesManager: currenciesManager))

}
