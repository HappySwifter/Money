//
//  SettingsManager.swift
//  Money
//
//  Created by Artem on 12.07.2024.
//

import Foundation

@Observable final class SettingsService {
    
    private let key = "AppSettings"
    private let defaults = UserDefaults.standard
    var appSettings: AppSettings
    
    init() {
        if let data = defaults.data(forKey: key),
           let set = try? JSONDecoder().decode(AppSettings.self, from: data) {
            appSettings = set
        } else {
            appSettings = AppSettings(isAccountNameInside: true)
        }
    }
    
    func save(settings: AppSettings) {
        self.appSettings = settings
        if let data = try? JSONEncoder().encode(settings) {
            defaults.setValue(data, forKey: key)
        } else {
            print("Error on save settings")
        }
    }
}
