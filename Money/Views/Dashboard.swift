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
import TipKit

@MainActor
struct Dashboard: View {
    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(ExpensesService.self) private var expensesService
    
    @Query(filter: Account.accountPredicate(),
           sort: \Account.orderIndex)
    private var accounts: [Account]
    
    @Query(filter: Account.categoryPredicate(),
           sort: \Account.orderIndex)
    private var categories: [Account]
    
    @State private var selectedAccount: Account?
    @State private var presentingType = PresentingType.none
    @State private var createAccountPresented = false
    @State private var createCategoryPresented = false
    
    @State private var dashboardTips = TipGroup(.ordered) {
        AccountTapTip()
        CategoryTapTip()
        CategoryLongPressTip()
    }
    
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
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("gradient_0"), Color("gradient_1")]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
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
                    .dynamicTypeSize(.xLarge ... .xLarge)

                    
                    TipView(dashboardTips.currentTip as? AccountTapTip, arrowEdge: .bottom) { action in
                        print(action)
                    }
                    ScrollView(.horizontal) {

                        HStack {
                            ForEach(accounts) { account in
                                AccountView(item: .constant(account),
                                            selected: Binding(
                                                get: { selectedAccount == account },
                                                set: { _ in
                                                    selectedAccount = account
                                                    let tip = dashboardTips.currentTip as? AccountTapTip
                                                    tip?.invalidate(reason: .actionPerformed)
                                                }),
                                            presentingType: $presentingType)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(width: Constants.Account.viewWidth)
                            }
                        }
                        .padding(.bottom, 10)
                    }
    //                .scrollIndicators(.hidden)
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
    //                    Spacer()
                    }
                    .buttonStyle(.plain)
                    .dynamicTypeSize(.xLarge ... .xLarge)
                    
                    TipView(dashboardTips.currentTip as? CategoryTapTip, arrowEdge: .bottom)
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .leading) {
                            ForEach(categories) { category in
                                CategoryView(item: .constant(category),
                                             tapHandler: categorySelectHandler(cat:),
                                             longPressHandler: categoryLongPressHandler(cat:))
                            }
                        }
                        TipView(dashboardTips.currentTip as? CategoryLongPressTip, arrowEdge: .top)
                    }
                    .accessibilityIdentifier(CategoriesScrollView)
                }
                .padding(.horizontal)
            }

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
        }
    }
    
    private func categorySelectHandler(cat: Account) {
        showImpact()
        let tip = dashboardTips.currentTip as? CategoryTapTip
        tip?.invalidate(reason: .actionPerformed)
        if let selectedAccount {
            presentingType = .transfer(source: selectedAccount, destination: cat)
        }
    }
    
    private func categoryLongPressHandler(cat: Account) {
        showImpact()
        let tip = dashboardTips.currentTip as? CategoryLongPressTip
        tip?.invalidate(reason: .actionPerformed)
        presentingType = .details(item: cat)
    }
}

@available(iOS 18.0, *)
#Preview(traits: .sampleData) {
    let currenciesManager = CurrenciesManager()
    let preferences = Preferences(currenciesManager: currenciesManager)
    let expensesService = ExpensesService(preferences: preferences)
    let appRootManager = AppRootManager()
    Dashboard()
        .modelContainer(DataProvider.shared.sharedModelContainer)
        .environment(\.dataHandler, DataProvider.shared.dataHandlerCreator())
        .environment(\.dataHandlerWithMainContext, DataProvider.shared.dataHandlerWithMainContextCreator())
        .environment(preferences)
        .environment(expensesService)
        .environment(appRootManager)
}


struct SampleData: PreviewModifier {
    static func makeSharedContext() async throws -> ModelContainer {
        let dataHandler = DataHandler(modelContainer: DataProvider.shared.previewContainer)
        let currenciesManager = CurrenciesManager()
        do {
            let myCur = MyCurrency(code: "USD", name: "Dollar", symbol: "S")
            try await dataHandler.populateWithMockData(userCurrency: myCur,
                                                       currencies: currenciesManager.currencies,
                                             iconNames: IconType.all.getIcons())
            return DataProvider.shared.previewContainer
        } catch {
            return DataProvider.shared.previewContainer
        }
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    @available(iOS 18.0, *)
    @MainActor static var sampleData: Self = .modifier(SampleData())
}
