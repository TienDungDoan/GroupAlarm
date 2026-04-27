//
//  MigrationManager.swift
//  GroupAlarmClock
//
//  Created by Tien Dung Doan on 27/4/26.
//

import Foundation

final class MigrationManager {
    
    static let shared = MigrationManager()
    
    private init() {}
    
    func runIfNeeded(groups: [GroupAlarm], schemaVersion: inout Int) {
        if schemaVersion < 1 {
            migrateToNewVersionIfNeeded(groups)
            schemaVersion = 1
        }
    }
    
    private func migrateToNewVersionIfNeeded(_ groups: [GroupAlarm]) {
        
        let needsFix = groups.allSatisfy { $0.order == 0 }
        
        guard needsFix else { return }
        
        for (index, group) in groups.enumerated() {
            group.order = index
            
            for (alarmIndex, alarm) in group.alarms.enumerated() {
                alarm.order = alarmIndex
            }
        }
        
        print("✅ Migration V2 applied")
    }
}
