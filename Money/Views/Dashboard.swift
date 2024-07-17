//
//  Dashboard.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
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
    
    @State private var selectedAccount: Account?
    @State private var plusPressed = false
    @State private var createAccountPresented = false
    @State private var createCategoryPresented = false
    @State private var settingsPresented = false
    @State private var presentingType = PresentingType.none
    
    private var sheetBinding: Binding<Bool> {
        Binding(
            get: { return self.presentingType != .none },
            set: { (newValue) in return self.presentingType = .none }
        )
    }
    
    private var columns: [GridItem] {
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
                        Text("Accounts: \(expensesService.accountsTotalAmount)")
                            .foregroundStyle(Color.gray)
                    }
                    .buttonStyle(.plain)
                    .padding(.vertical)
                    .accessibilityIdentifier(AllAccountButton)
                    
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
                            if !expensesService.spentToday.isEmpty {
                                Text("Spent today: \(expensesService.spentToday)")
                            }
                            if !expensesService.spentThisMonth.isEmpty {
                                Text("Spent this month: \(expensesService.spentThisMonth)")
                            }
                        }
                        .foregroundStyle(Color.gray)
                        .font(.footnote)
                    }
                    Spacer()
                    if !expensesService.availableYears.isEmpty {
                        NavigationLink {
                            ReportView()
                        } label: {
                            Image("pie")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .opacity(0.5)
                        }
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
                .accessibilityIdentifier(CategoriesScrollView)
                
                Button("", systemImage: "gearshape") {
                    settingsPresented.toggle()
                }
            }
            .padding()
            .onChange(of: accounts, initial: true) {
                selectedAccount = accounts.first
            }
//            .task(id: accounts) {
//                
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
            .sheet(isPresented: $settingsPresented) {
                SettingsView()
            }
        }
    }
    
    private func itemPressHandler(item: Account) {
        if let selectedAccount {
            showImpact()
            presentingType = .transfer(source: selectedAccount, destination: item)
        }
    }
    
    private func itemLongPressHandler(item: Account) {
        showImpact()
        presentingType = .details(item: item)
    }
}

#Preview {
    Dashboard()
}
