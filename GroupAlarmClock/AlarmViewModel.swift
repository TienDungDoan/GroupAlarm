//
//  AlarmViewModel.swift
//  GroupAlarmClock
//
//  Created by Tien Dung Doan on 26/4/26.
//

import Foundation
import SwiftData

final class AlarmViewModel {
    
    private var context: ModelContext
        
    init(context: ModelContext) {
        self.context = context
    }
    
    func addGroup() {
        context.insert(GroupAlarm())
    }

    func deleteGroup(_ group: GroupAlarm) {
        context.delete(group)
    }
    
    func deleteAlarm(_ alarm: Alarm) {
        context.delete(alarm)
    }
    
    func addAlarm(to group: GroupAlarm) {
        let newAlarm = Alarm(timestamp: Date())
        context.insert(newAlarm)
        group.alarms.append(newAlarm)
    }
    
    func updateTitleGroup(newTitle: String, for group: GroupAlarm) {
        let trimmed = newTitle.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        
        group.title = trimmed
        try? context.save()
    }
    
}
