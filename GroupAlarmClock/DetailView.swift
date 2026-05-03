//
//  DetailView.swift
//  GroupAlarmClock
//
//  Created by Tien Dung Doan on 2/5/26.
//

import SwiftUI

struct DetailView: View {
    @Bindable var alarm: Alarm
    @State private var draft: AlarmDraft
    
    var onClose: () -> Void
    
    init(alarm: Alarm, onClose: @escaping () -> Void) {
        self.alarm = alarm
        self.onClose = onClose
        _draft = State(initialValue: AlarmDraft(from: alarm))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                DatePicker(
                    "",
                    selection: $draft.timestamp,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                
                Section {
                    HStack {
                        Text("Repeat")
                        Spacer()
                        Text("Never")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Label")
                        Spacer()
                        Text(draft.note.isEmpty ? "Alarm" : draft.note)
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Sound")
                        Spacer()
                        Text("Default")
                            .foregroundStyle(.secondary)
                    }
                    
                    Toggle("Snooze", isOn: $draft.isActive)
                }
                
                Section {
                    Button(role: .destructive) {
                        // delete logic
                    } label: {
                        Text("Delete Alarm")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("Edit Alarm")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { onClose() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        alarm.apply(from: draft)
                        onClose()
                    }
                    .disabled(draft.timestamp == alarm.timestamp &&
                              draft.note == alarm.note &&
                              draft.isActive == alarm.isActive)
                }
            }
        }
    }
}

#Preview {
    DetailView(alarm: Alarm(timestamp: Date(), order: 0)) {
        
    }
}
