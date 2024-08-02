//
//  Dashboard.swift
//  Money
//
//  Created by Artem on 28.02.2024.
//

import Foundation
import SwiftUI
import SwiftData
import DataProvider

@MainActor
struct Dashboard: View {
    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(Preferences.self) private var preferences
    @Environment(ExpensesService.self) private var expensesService
    
    @Query(filter: Account.accountPredicate(),
           sort: \Account.orderIndex)
    private var accounts: [Account]
    
    @Query(
        filter: Account.categoryPredicate(),
        sort: \Account.orderIndex)
    private var categories: [Account]
    
    @State private var selectedAccount: Account?
    @State private var createAccountPresented = false
    @State private var createCategoryPresented = false
    @State private var settingsPresented = false
    @State private var presentingType = PresentingType.none
    
    private var sheetBinding: Binding<Bool> {
        Binding(
            get: { return self.presentingType != .none },
            set: { _ in return self.presentingType = .none }
        )
    }
    
    private var columns: [GridItem] {
        let count: Int
        switch horizontalSizeClass {
        case .compact:
            if sizeCategory == .extraSmall {
                count = 5
            } else if sizeCategory == .accessibilityMedium {
                count = 3
            } else if sizeCategory.isAccessibilityCategory {
                count = 2
            } else {
                count = 4
            }
        case .regular:
            count = sizeCategory.isAccessibilityCategory ? 4 : 8
        default:
            count = 0
        }
        return Array(repeating: .init(.flexible(minimum: 60)), count: count)
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    NavigationLink {
                        AllAccountsView()
                    } label: {
                        Text("Accounts: \(expensesService.accountsTotalAmount)")
                            .foregroundStyle(Color.gray)
                            .truncationMode(.head)
                    }
                    .buttonStyle(.plain)
                    .padding(.vertical)
                    .accessibilityIdentifier(AllAccountButton)
                    
                    Spacer()
                    MenuView(selectedAccount: $selectedAccount,
                             presentingType: $presentingType)
                }
                .dynamicTypeSize(.xSmall ... .accessibility1)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(accounts) { account in
                            AccountView(item: account,
                                        currencySymbol: account.currency?.symbol,
                                        selected: Binding(
                                            get: { selectedAccount == account },
                                            set: { _ in selectedAccount = account }),
                                        presentingType: $presentingType)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                    .padding(.vertical, 5)
                
                HStack {
                    NavigationLink {
                        HistoryView()
                    } label: {
                        VStack(alignment: .leading) {
                            Text("Spent today: \(expensesService.spentToday)")
                                .truncationMode(.head)
                            Text("This month: \(expensesService.spentThisMonth)")
                                .truncationMode(.head)
                        }
                        .lineLimit(1)
                        .foregroundStyle(Color.gray)
                        .font(.callout)
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
                .dynamicTypeSize(.xSmall ... .accessibility2)
                
                ScrollView {
                    LazyVGrid(columns: columns, alignment: .leading) {
                        ForEach(categories) {
                            CategoryView(item: $0,
                                         selectedAccount: selectedAccount,
                                         presentingType: $presentingType)
                        }
                    }
                }
                .accessibilityIdentifier(CategoriesScrollView)
                
                Button("", systemImage: "gearshape") {
                    settingsPresented.toggle()
                }
                .dynamicTypeSize(.xxLarge ... .accessibility1)
            }
            .padding()
            .onChange(of: accounts, initial: true) {
                selectedAccount = accounts.first
            }
            .sheet(isPresented: sheetBinding) {
                ActionSheetView(isPresented: sheetBinding, presentingType: presentingType)
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
}
