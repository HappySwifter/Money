//
//  SettingsView.swift
//  Money
//
//  Created by Artem on 11.07.2024.
//

import SwiftUI


struct SettingsView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(SettingsService.self) private var settings
    @Environment(AppRootManager.self) private var rootManager
    
    @State private var accountNameIsInside = true
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Account") {
                    Toggle(isOn: $accountNameIsInside, label: {
                        Text("Name is inside")
                    })
                }
                Section("App data") {
                    Button("Delete data") {
                        deleteAllData()
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
            .onAppear {
                accountNameIsInside = settings.appSettings.isAccountNameInside
            }
        }
    }
        
    private func save() {
        let appSettings = AppSettings(isAccountNameInside: accountNameIsInside)
        settings.save(settings: appSettings)
    }
    
    private func deleteAllData() {
        do {
            try context.delete(model: Account.self)
            try context.delete(model: MyCurrency.self)
            try context.delete(model: Transaction.self)
            
            rootManager.updateRoot()
        } catch {
            print(error)
        }
        
    }
}

#Preview {
    SettingsView()
}
