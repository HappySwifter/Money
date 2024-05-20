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
    @Environment(ExpensesService.self) private var expensesService
    
    @Query(filter: Account.accountPredicate(),
           sort: \Account.orderIndex)
    private var accounts: [Account]
    
    @Query(
        filter: Account.categoryPredicate(),
        sort: \Account.orderIndex)
    private var categories: [Account]
    
//    @Query(filter: Transaction.todayPredicate())
//    private var todayTransactions: [Transaction]
//    
//    @Query(filter: Transaction.thisMonthPredicate())
//    private var thisMonthTransactions: [Transaction]
    
    @State var totalAmount = ""
//    @State var spentToday = ""
//    @State var spentThisMonth = ""
    @State var selectedAccount: Account?
    @State var plusPressed = false
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
                
                
                HStack {
                    NavigationLink {
                        AllAccountsView(userCurrency: preferences.getUserCurrency())
                    } label: {
                        Text("Accounts: \(totalAmount) >")
                            .foregroundStyle(Color.gray)
                    }
                    .buttonStyle(.plain)
                    .padding(.vertical)
                    
                    Spacer()
                    MenuView(selectedAccount: selectedAccount,
                             buttonPressed: $plusPressed,
                             presentingType: $presentingType)
                }

                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(accounts) { item in
                            AccountView(item: item,
                                        currency: .constant(item.currency),
                                        selected: Binding(
                                            get: { selectedAccount == item },
                                            set: { _ in selectedAccount = item }),
                                        longPressHandler: itemLongPressHandler(item:))
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                    .padding(.vertical)

                HStack {
                    NavigationLink {
                        HistoryView()
                    } label: {
                        VStack(alignment: .leading) {
                            Text("Spent today: \(expensesService.spentToday)")
                            Text("Spent this month: \(expensesService.spentThisMonth)")
                        }
                        .foregroundStyle(Color.gray)
                        .font(.footnote)
                    }
                    Spacer()
                    NavigationLink {
                        ReportView()
                    } label: {
                        Image("pie")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .opacity(0.5)
                    }
                }
                .buttonStyle(.plain)
                
                ScrollView {
                    LazyVGrid(columns: columns, alignment: .leading) {
                        ForEach(categories) { item in
                            CategoryView(item: item,
                                         pressHandler: itemPressHandler(item:),
                                         longPressHandler: itemLongPressHandler(item:))
                        }
                    }
                }
            }
            .padding()
//            .onAppear {
//                updateTotal(type: .today)
//                updateTotal(type: .month)
//            }
            .onChange(of: accounts, initial: true, {
                selectedAccount = accounts.first
                calculateAccountsTotal(from: accounts)
            })
//            .onChange(of: todayTransactions) {
//                updateTotal(type: .today)
//            }
//            .onChange(of: thisMonthTransactions) {
//                updateTotal(type: .month)
//            }
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
        if let selectedAccount {
            presentingType = .transfer(source: selectedAccount, destination: item)
        }
    }
    
    func itemLongPressHandler(item: Account) {
        presentingType = .details(item: item)
    }
    
    private func calculateAccountsTotal(from accounts: [CurrencyConvertible]) {
        Task {
            do {
                let userCode = preferences.getUserCurrency().code
                let rates = try await currenciesApi.getExchangeRateFor(currencyCode: userCode, date: Date())
                
                var totalAmount = 0.0
                for account in accounts {
                    if let changeRate = rates.currency[userCode]?[account.currency!.code] {
                        totalAmount += account.getAmountWith(changeRate: changeRate)
                    } else {
                        print("No conversation rate for \(account.currency!.code)")
                    }
                }
                self.totalAmount = getAmountStringWith(code: userCode, val: totalAmount)
            } catch {
                print(error)
            }
        }
    }
    
//    enum SpentType {
//        case today
//        case month
//    }
    
//    private func updateTotal(type: SpentType) {
//        Task {
//            do {
//                let userCode = preferences.getUserCurrency().code
//                switch type {
//                case .today:
//                    let total = try await calculateSpent(for: todayTransactions)
//                    spentToday = total.getString() + " " + userCode
//                case .month:
//                    let total = try await calculateSpent(for: thisMonthTransactions)
//                    spentThisMonth = total.getString() + " " + userCode
//                }
//            } catch {
//                print(error)
//            }
//        }
//    }
    
//    private func calculateSpent(for transactions: [Transaction]) async throws -> Double {
//        let userCode = preferences.getUserCurrency().code
//        let rates = try await currenciesApi.getExchangeRateFor(currencyCode: userCode, date: Date()) 
//        return transactions.reduce(0.0) { total, tran in
//            if let sourceCurrency = tran.source.currency {
//                if userCode == sourceCurrency.code {
//                    return total + tran.sourceAmount
//                } else {
//                    if let exchRate = rates.value(for: sourceCurrency.code) {
//                        return total + tran.sourceAmount / exchRate
//                    } else {
//                        print("ERROR no rate for code", sourceCurrency.code)
//                        return total
//                    }
//                }
//            } else {
//                return total
//            }
//        }
//    }
    
}

#Preview {
    Dashboard()
}
