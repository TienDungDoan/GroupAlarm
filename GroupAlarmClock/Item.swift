//
//  Alarm.swift
//  GroupAlarmClock
//
//  Created by Tien Dung Doan on 22/2/26.
//

import Foundation
import SwiftData

@Model
final class Alarm {
    var timestamp: Date
    var note: String
    var isActive: Bool
    
    init(timestamp: Date, note: String = "", isActive: Bool = true) {
        self.timestamp = timestamp
        self.note = note
        self.isActive = isActive
    }
    
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: timestamp)
    }
}

@Model
final class GroupAlarm {
    var title: String
    @Relationship(deleteRule: .cascade)
    var alarms: [Alarm]
    var isExpanded: Bool = true
    
    init(title: String, alarms: [Alarm]) {
        self.title = title
        self.alarms = alarms
    }
    
    init() {
        self.title = "New Group"
        self.alarms = []
    }
}
