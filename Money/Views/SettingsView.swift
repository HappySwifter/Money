//
//  SettingsView.swift
//  Money
//
//  Created by Artem on 11.07.2024.
//

import SwiftUI


struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(SettingsService.self) private var settings
    @State private var accountNameIsInside = true
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Account") {
                    Toggle(isOn: $accountNameIsInside, label: {
                        Text("Name is inside")
                    })
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
}

#Preview {
    SettingsView()
}
