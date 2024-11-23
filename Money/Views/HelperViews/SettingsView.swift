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
    @Environment(CurrenciesManager.self) private var currenciesManager
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Walkthrough") {
                    Button("Show walkthrough") {
                        rootManager.currentRoot = .addDataHelper
                    }
                }
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
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func deleteAllData() {
        Task { @MainActor in
            do {
                try await dataHandler?.clearDB()
                rootManager.updateRoot()
            } catch {
                logger.error("\(error.localizedDescription)")
            }
        }
    }
    
    private func populateWithMockRandomData() {
        Task {
            do {
                try await dataHandler?.populateWithMockData(iconNames: IconType.all.getIcons()
                )
                dismiss()
            } catch {
                logger.error("\(error.localizedDescription)")
            }
        }
    }
}
