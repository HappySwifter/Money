//
//  CloudKitManager.swift
//  Money
//
//  Created by Artem on 16.11.2024.
//

import Foundation
import CoreData

struct CloudKitManager {
    enum CloudKitSyncStatus {
        case still
        case importing
        case finishImporting
    }
    
    static func getCloudKitSyncStatus(completion: @escaping (CloudKitSyncStatus) -> ()) {
        
        NotificationCenter.default.addObserver(forName: NSPersistentCloudKitContainer.eventChangedNotification, object: nil, queue: .main) { notification in
            
            guard let event = notification.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey] as? NSPersistentCloudKitContainer.Event else {
                completion(.still)
                return
            }
            let isFinished = event.endDate != nil
            
            switch (event.type, isFinished) {
            case (.import, false):
                print("Start import")
                completion(.importing)
            case (.import, true):
                print("Finish import")
                completion(.finishImporting)
            default:
                print("Unknown event \(event.description)")
                completion(.still)
            }
        }
    }
    
    static func stopObservingChanges() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSPersistentCloudKitContainer.eventChangedNotification,
                                                  object: nil)
    }

}
