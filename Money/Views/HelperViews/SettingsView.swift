//
//  SettingsView.swift
//  Money
//
//  Created by Artem on 11.07.2024.
//

import SwiftUI
import DataProvider
import OSLog

@MainActor
struct SettingsView: View {
    private let logger = Logger(subsystem: "Money", category: "SettingsView")
    private let defaults = UserDefaults.standard
    @Environment(\.dataHandlerWithMainContext) private var dataHandler
    @Environment(\.dismiss) private var dismiss
    @Environment(AppRootManager.self) private var rootManager
    @Environment(Preferences.self) private var preferences
//    @State private var accountNameIsInside = true
    
    var body: some View {
        NavigationStack {
            Form {
//                Section("Account") {
//                    Toggle(isOn: $accountNameIsInside, label: {
//                        Text("Name is inside")
//                    })
//                }
                Section("App data") {
                    Button("Delete data") {
                        deleteAllData()
                    }
                    .foregroundStyle(.red)
                    Button("Populate with mock random data") {
                        populateWithMockRandomData()
                    }
                    .foregroundStyle(.red)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem {
                    Button("Save") {
                        save()
                        dismiss()
                    }
                }
            }
//            .onAppear {
//                accountNameIsInside = defaults.bool(forKey: AppSettings.isAccountNameInside)
//            }
        }
    }
        
    private func save() {
//        defaults.setValue(accountNameIsInside, forKey: AppSettings.isAccountNameInside)
    }
    
    private func deleteAllData() {
        Task { @MainActor in
            do {
                try await dataHandler()?.clearDB()
                rootManager.updateRoot()
            } catch {
                logger.error("\(error.localizedDescription)")
            }
        }
    }
    
    private func populateWithMockRandomData() {
        Task {
            do {
                let userCurrency = try await preferences.getUserCurrency()
                try await dataHandler()?.populateWithMockData(
                    userCurrency: userCurrency,
                    iconNames: IconType.all.getIcons()
                )
                dismiss()
            } catch {
                logger.error("\(error.localizedDescription)")
            }
        }
    }
}
