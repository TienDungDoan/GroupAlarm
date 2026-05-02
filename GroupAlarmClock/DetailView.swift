//
//  DetailView.swift
//  GroupAlarmClock
//
//  Created by Tien Dung Doan on 2/5/26.
//

import SwiftUI

struct DetailView: View {
    @Bindable var alarm: Alarm
    var onClose: () -> Void
    var onSave: () -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                DatePicker(
                    "",
                    selection: $alarm.timestamp,
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
                        Text(alarm.note.isEmpty ? "Alarm" : alarm.note)
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Sound")
                        Spacer()
                        Text("Default")
                            .foregroundStyle(.secondary)
                    }
                    
                    Toggle("Snooze", isOn: $alarm.isActive)
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
                    Button("Save") { onSave() }
                }
            }
        }
    }
}

#Preview {
    DetailView(alarm: Alarm(timestamp: Date(), order: 0)) {
        
    } onSave: {
        
    }
}
