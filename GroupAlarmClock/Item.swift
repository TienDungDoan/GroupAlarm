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
    var id: UUID = UUID()
    var timestamp: Date
    var note: String
    var isActive: Bool
    var order: Int
    
    var group: GroupAlarm?
    
    init(timestamp: Date, note: String = "", isActive: Bool = true, order: Int) {
        self.timestamp = timestamp
        self.note = note
        self.isActive = isActive
        self.order = order
    }
    
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: timestamp)
    }
    
    func apply(from draft: AlarmDraft) {
        timestamp = draft.timestamp
        note = draft.note
        isActive = draft.isActive
    }
}

struct AlarmDraft {
    var timestamp: Date
    var note: String
    var isActive: Bool
    
    init(from alarm: Alarm) {
        self.timestamp = alarm.timestamp
        self.note = alarm.note
        self.isActive = alarm.isActive
    }
}

@Model
final class GroupAlarm {
    var id: UUID = UUID()
    var title: String
    
    @Relationship(deleteRule: .cascade)
    var alarms: [Alarm]
    
    var isExpanded: Bool = true
    var order: Int
    
    init(title: String, alarms: [Alarm], order: Int) {
        self.title = title
        self.alarms = alarms
        self.order = order
        
        for alarm in alarms {
            alarm.group = self
        }
    }
    
    init() {
        self.title = "New Group"
        self.alarms = []
        self.order = 0
    }
}
