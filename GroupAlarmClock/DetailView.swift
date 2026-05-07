//
//  DetailView.swift
//  GroupAlarmClock
//
//  Created by Tien Dung Doan on 2/5/26.
//

import SwiftUI

enum Destination {
    case repeatSelection
    case soundSelection
}

struct DetailView: View {
    @Bindable var alarm: Alarm
    @State private var draft: AlarmDraft
    let viewModel : AlarmViewModel
    @State private var destination: Destination?
    
    var onClose: () -> Void
    
    init(alarm: Alarm, viewModel: AlarmViewModel, onClose: @escaping () -> Void) {
        self.alarm = alarm
        self.onClose = onClose
        self.viewModel = viewModel
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
                    SettingRow(title: "Repeat", value: "Never") {
                        destination = .repeatSelection
                    }
                    
                    SettingRow(title: "Label", text: $draft.note)
                    
                    SettingRow(title: "Sound", value: "Default") {
                        destination = .soundSelection
                    }
                    
                    Toggle("Snooze", isOn: $draft.isActive)
                }
                
                Section {
                    Button(role: .destructive) {
                        viewModel.deleteAlarm(alarm)
                        onClose()
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
            .navigationDestination(item: $destination) { destination in
                switch destination {
                case .repeatSelection:
                    SelectionListView(
                        title: "Repeat",
                        selectionType: .weekdays,
                        selectedItem: $draft.note
                    )
                case .soundSelection:
                    SelectionListView(
                        title: "Sound",
                        selectionType: .sounds,
                        selectedItem: $draft.note
                    )
                }
            }
        }
    }
}

struct SettingRow: View {
    let title: String
    var value: String?
    var text: Binding<String>? = nil
    var action: (() -> Void)? = nil
    
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            
            if let text, isEditing {
                TextField("", text: text)
                    .multilineTextAlignment(.trailing)
                    .focused($isFocused)
                    .onSubmit { finishEdit() }
                    .onAppear { isFocused = true }
            } else {
                Text(displayValue)
                    .foregroundStyle(.secondary)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            handleTap()
        }
        .onChange(of: isFocused) { _, focused in
            if !focused && isEditing {
                finishEdit()
            }
        }
    }
    
    private var displayValue: String {
        if let text = text?.wrappedValue {
            return text.isEmpty ? "" : text
        }
        return value ?? ""
    }
    
    private func handleTap() {
        if text != nil {
            isEditing = true
        } else {
            action?()
        }
    }
    
    private func finishEdit() {
        isEditing = false
        isFocused = false
    }
}

//#Preview {
//    DetailView(alarm: Alarm(timestamp: Date(), order: 0)) {
//        
//    }
//}
