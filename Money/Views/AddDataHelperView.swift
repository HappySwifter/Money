//
//  AddDataHelperView.swift
//  Money
//
//  Created by Artem on 11.07.2024.
//

import SwiftUI
import SwiftData

struct AddDataHelperView: View {
    @Environment(AppRootManager.self) private var appRootManager
    @Environment(Preferences.self) private var preferences
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.green.opacity(0.5), .blue.opacity(0.5)]),
                           startPoint: .top,
                           endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack(alignment: .center) {
                Text("Welcome to the My Money app!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.vertical)
                
                IconView(icon: Icon(name: "tree.fill", color: .green, isMulticolor: true), font: .system(size: 100), heightLimit: nil)
                
                Spacer()
                
                Text("Start by adding accounts and categories.")
                    .font(.title3)
                    .padding(.bottom)
                
                Button {
                    addTestData()
                } label: {
                    Text("Add test data")
                }
                .buttonStyle(StretchedRoundedButtonStyle())
                .padding(.bottom)
                
                Button {
                    appRootManager.currentRoot = .addAccount
                } label: {
                    Text("I will create by myself")
                }
                .buttonStyle(StretchedRoundedButtonStyle())
            }
            .padding()
        }
        
    }
    
    private func addTestData() {
        let userCurrency = preferences.getUserCurrency()
        
        let accDesc = FetchDescriptor<Account>()
        let accountsCount = (try? modelContext.fetchCount(accDesc)) ?? 0
        
        let accountCash = Account(orderIndex: accountsCount,
                                  name: "Cash",
                                  color: .blue,
                                  isAccount: true,
                                  amount: 1000)
        
        let accountBank = Account(orderIndex: accountsCount + 1,
                                  name: "Bank",
                                  color: .blue,
                                  isAccount: true,
                                  amount: 10000)
        
        let categoryFood = Account(orderIndex: accountsCount + 2,
                                   name: "Food",
                                   color: .clear,
                                   isAccount: false,
                                   amount: 0)
        
        let categoryClothes = Account(orderIndex: accountsCount + 3,
                                      name: "Clothes",
                                      color: .clear,
                                      isAccount: false,
                                      amount: 0)
        
        
        
        accountCash.currency = userCurrency
        accountCash.icon = Icon(name: "banknote", color: .green, isMulticolor: false)
        
        accountBank.currency = userCurrency
        accountBank.icon = Icon(name: "creditcard", color: .blue, isMulticolor: false)
        
        categoryFood.icon = Icon(name: "basket", color: .indigo, isMulticolor: false)
        categoryClothes.icon = Icon(name: "tshirt", color: .orange, isMulticolor: false)
        modelContext.insert(categoryFood)
        modelContext.insert(categoryClothes)
        
        appRootManager.currentRoot = .dashboard
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: MyCurrency.self, Account.self, Transaction.self, configurations: config)
    
    let rootManager = AppRootManager(modelContext: container.mainContext)
    
    let pref = Preferences(userDefaults: .standard, modelContext: container.mainContext)
    
    return AddDataHelperView()
        .modelContainer(container)
        .environment(rootManager)
        .environment(pref)
}
