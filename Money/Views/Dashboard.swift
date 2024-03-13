//
//  Dashboard.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import Foundation
import SwiftUI
import SwiftData

struct Dashboard: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(Preferences.self) private var preferences
    @Environment(CurrenciesApi.self) private var currenciesApi
    
    @Query(filter: #Predicate<Account> { $0.isAccount },
           sort: \Account.orderIndex)
    private var accounts: [Account]
    
    @Query(
        filter: #Predicate<Account> { !$0.isAccount },
        sort: \Account.date)
    private var categories: [Account]
    
    
    @State var totalAmount = ""
    @State var selectedAccount: Account?
    @State var createAccountPresented = false
    @State var createCategoryPresented = false
    @State var presentingType = PresentingType.none
    
    var sheetBinding: Binding<Bool> {
        Binding(
            get: { return self.presentingType != .none },
            set: { (newValue) in return self.presentingType = .none }
        )
    }
    
    var columns: [GridItem] {
        let count: Int
        switch horizontalSizeClass {
        case .compact:
            count = 4
        case .regular:
            count = 8
        default:
            count = 0
        }
        return Array(repeating: .init(.flexible(minimum: 60)), count: count)
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                NavigationLink {
                    AllAccountsView(userCurrency: preferences.getUserCurrency())
                } label: {
                    Text("Accounts: \(totalAmount) >")
                        .foregroundStyle(Color.gray)
                }
                .buttonStyle(.plain)
                .padding(.vertical)

                ScrollView(.horizontal) {
                    HStack {
                        ForEach(accounts) { item in
                            AccountView(item: item,
                                        selected: Binding(
                                            get: { selectedAccount == item },
                                            set: { _ in selectedAccount = item }),
                                        longPressHandler: itemLongPressHandler(item:))
                        }
                        PlusView(buttonPressed: $createAccountPresented)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                    .padding(.vertical)
                
                NavigationLink {
                    ExpensesView()
                } label: {
                    Text("This month -$123 >")
                        .foregroundStyle(Color.gray)
                }
                .buttonStyle(.plain)

                ScrollView {
                    LazyVGrid(columns: columns, alignment: .leading) {
                        ForEach(categories) { item in
                            CategoryView(item: item,
                                         pressHandler: itemPressHandler(item:),
                                         longPressHandler: itemLongPressHandler(item:))
                        }
                        PlusView(buttonPressed: $createCategoryPresented)
                    }
                }
            }
            .padding()
            .onChange(of: accounts, initial: true, {
                selectedAccount = accounts.first
                calculateAccountsTotal(from: accounts)
            })
            .sheet(isPresented: sheetBinding) { ActionSheetView(
                isPresented: sheetBinding,
                presentingType: presentingType)
            }
            .sheet(isPresented: $createAccountPresented) {
                ActionSheetView(isPresented: $createAccountPresented, presentingType: .addAccount)
            }
            .sheet(isPresented: $createCategoryPresented) {
                ActionSheetView(isPresented: $createCategoryPresented, presentingType: .addCategory)
            }
        }
    }
    
    func itemPressHandler(item: Account) {
        presentingType = .transfer(source: selectedAccount, destination: item)
    }
    
    func itemLongPressHandler(item: Account) {
        presentingType = .details(item: item)
    }
    
    func calculateAccountsTotal(from accounts: [CurrencyConvertible]) {
        Task {
            do {
                let userCode = preferences.getUserCurrency().code
                let rates = try await currenciesApi.getExchangeRateFor(currencyCode: userCode, date: Date())
                
                var totalAmount = 0.0
                for account in accounts {
                    if let changeRate = rates.currency[userCode]?[account.accountDetails!.currency!.code] {
                        totalAmount += account.getAmountWith(changeRate: changeRate)
                    } else {
                        print("No conversation rate for \(account.accountDetails!.currency!.code)")
                    }
                }
                self.totalAmount = getAmountStringWith(code: userCode, val: totalAmount)
            } catch {
                print(error)
            }
        }
    }
    

}

#Preview {
    Dashboard()
}
