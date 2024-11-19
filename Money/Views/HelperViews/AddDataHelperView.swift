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
struct AddDataHelperView: View {
    private let logger = Logger(subsystem: "Money", category: "AddDataHelperView")
    @Environment(AppRootManager.self) private var appRootManager
    @Environment(Preferences.self) private var preferences
    @Environment(CurrenciesManager.self) private var currenciesManager
    @Environment(\.dataHandlerWithMainContext) private var dataHandler
    
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
                
                IconView(icon: Icon(name: "tree.fill", color: .green), font: .system(size: 100))
                
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
                
                #if DEBUG
                Button {
                    populateWithMockRandomData()
                } label: {
                    Text("Get bunch of random data")
                }
                .buttonStyle(StretchedRoundedButtonStyle())
                .padding(.bottom)
                #endif
                
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
        let dataHandler = dataHandler
        Task { @MainActor in
            do {
                if let dataHandler = await dataHandler() {
                    let userCurrency = preferences.getUserCurrency()
                    try await dataHandler.addTestData(userCurrency: userCurrency)
                    appRootManager.currentRoot = .dashboard
                }
            } catch {
                logger.error("\(error.localizedDescription)")
            }
        }
    }
    
    private func populateWithMockRandomData() {
        Task {
            do {
                let userCurrency = preferences.getUserCurrency()
                try await dataHandler()?.populateWithMockData(
                    userCurrency: userCurrency,
                    currencies: currenciesManager.currencies,
                    iconNames: IconType.all.getIcons()
                )
                appRootManager.currentRoot = .dashboard
            } catch {
                logger.error("\(error.localizedDescription)")
            }
        }
    }
}

//#Preview {
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: MyCurrency.self, Account.self, MyTransaction.self, configurations: config)
//    
//    let rootManager = AppRootManager()
//    
//    let pref = Preferences(userDefaults: .standard)
//    
//    return AddDataHelperView()
//        .modelContainer(container)
//        .environment(rootManager)
//        .environment(pref)
//}
