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
        let groups = fetchGroupsSorted()
        for group in groups {
            group.order += 1
        }
        
        let newGroup = GroupAlarm(
            title: "New Group",
            alarms: [],
            order: 0
        )
        context.insert(newGroup)
    }
    
    func fetchGroupsSorted() -> [GroupAlarm] {
        let descriptor = FetchDescriptor<GroupAlarm>(
            sortBy: [SortDescriptor(\.order)]
        )
        
        return (try? context.fetch(descriptor)) ?? []
    }
    
    func deleteGroup(_ group: GroupAlarm) {
        context.delete(group)
    }
    
    func deleteAlarm(_ alarm: Alarm) {
        context.delete(alarm)
    }
    
    func addAlarm(to group: GroupAlarm) {
        let nextOrder = (group.alarms.map { $0.order }.max() ?? -1) + 1
        let newAlarm = Alarm(timestamp: Date(), order: nextOrder)
        context.insert(newAlarm)
        group.alarms.append(newAlarm)
    }
    
    func normalizeOrder(_ groups: [GroupAlarm]) {
        let needsFix = groups.enumerated().contains {
            $0.element.order != $0.offset
        }
        
        guard needsFix else { return }
        
        let sorted = groups.sorted { $0.order < $1.order }
        
        for (index, group) in sorted.enumerated() {
            group.order = index
            group.alarms = group.alarms.sorted { $0.order < $1.order }
        }
    }
    
    func updateTitleGroup(newTitle: String, for group: GroupAlarm) {
        let trimmed = newTitle.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        
        group.title = trimmed
        try? context.save()
    }
    
}
