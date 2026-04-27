//
//  GroupAlarmClockApp.swift
//  GroupAlarmClock
//
//  Created by Tien Dung Doan on 22/2/26.
//

import SwiftUI
import SwiftData

@main
struct GroupAlarmClockApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Alarm.self, GroupAlarm.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
