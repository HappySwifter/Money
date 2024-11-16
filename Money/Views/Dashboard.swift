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
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(accounts) { account in
                                AccountView(item: .constant(account),
                                            selected: Binding(
                                                get: { selectedAccount == account },
                                                set: { _ in selectedAccount = account }),
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
                    
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .leading) {
                            ForEach(categories) {
                                CategoryView(item: .constant($0),
                                             selectedAccount: selectedAccount,
                                             presentingType: $presentingType)
                            }
                        }
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
}

@available(iOS 18.0, *)
#Preview(traits: .sampleData) {
    let preferences = Preferences()
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

        
            do {
                
                let currenciesFromJson = try MyCurrency.loadFromJson()
                let symbols = try CurrencySymbol.loadFromJson()
                print(symbols)
                for (code, name) in currenciesFromJson where !code.isEmpty && !name.isEmpty {
                    let symbol = symbols.findWith(code: code)?.symbol
                    await dataHandler.newCurrency(name: name,
                                                  code: code,
                                                  symbol: symbol)
                }
                
                try await dataHandler.populateWithMockData(userCurrency: MyCurrency(code: "USD", name: "Dollar", symbol: "S"),
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
