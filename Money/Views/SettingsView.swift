//
//  SettingsView.swift
//  Money
//
//  Created by Artem on 11.07.2024.
//

import SwiftUI

struct AppSettings: Codable {
    let isAccountNameInside: Bool
}

class SettingsRepository {
    private static let key = "AppSettings"
    private static let defaults = UserDefaults.standard
   
    private static var defaultSettings: AppSettings {
        AppSettings(isAccountNameInside: true)
    }
    
    static func save(settings: AppSettings) {
        let data = try? JSONEncoder().encode(settings)
        defaults.setValue(data, forKey: key)
        defaults.synchronize()
    }
    
    static func getSettings() -> AppSettings {
        if let data = defaults.data(forKey: key),
           let settings = try? JSONDecoder().decode(AppSettings.self, from: data) {
            return settings
        } else {
            return defaultSettings
        }
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var accountNameIsInside: Bool
    
    init() {
        let settings = SettingsRepository.getSettings()
        accountNameIsInside = settings.isAccountNameInside
    }
    
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
        }
    }
        
    private func save() {
        let settings = AppSettings(isAccountNameInside: accountNameIsInside)
        SettingsRepository.save(settings: settings)
    }
}

#Preview {
    SettingsView()
}
