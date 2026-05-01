//
//  ContentView.swift
//  GroupAlarmClock
//
//  Created by Tien Dung Doan on 22/2/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("schema_version") private var schemaVersion: Int = 1
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \GroupAlarm.order) private var groupAlarms: [GroupAlarm]
    
    @State private var editingGroupID: PersistentIdentifier?
    @State private var editingText: String = ""
    @FocusState private var isEditing: Bool
    
    @State private var selectedGroup: GroupAlarm?
    @State private var selectedAlarm: Alarm?
    
    private var viewModel: AlarmViewModel {
        AlarmViewModel(context: modelContext)
    }
    
    private func timePickerSheet(_ alarm: Alarm) -> some View {
        VStack {
            DatePicker(
                "",
                selection: Binding(
                    get: { alarm.timestamp },
                    set: { alarm.timestamp = $0 }
                ),
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            Button("Done") {
                selectedAlarm = nil
            }
            .padding()
        }
        .presentationDetents([.medium])
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(groupAlarms, id: \.id) { group in
                    groupSection(group)
                }
                .onDelete(perform: deleteGroup)
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        addGroup()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $selectedAlarm) { alarm in
                timePickerSheet(alarm)
            }
        }
        .onAppear {
            MigrationManager.shared.runIfNeeded(
                groups: groupAlarms,
                schemaVersion: &schemaVersion
            )
            viewModel.normalizeOrder(groupAlarms)
        }
    }
    
    @ViewBuilder
    private func groupSection(_ group: GroupAlarm) -> some View {
        DisclosureGroup(
            isExpanded: Binding(
                get: { group.isExpanded },
                set: { newValue in
                    withAnimation {
                        group.isExpanded = newValue
                    }
                }
            )
        ) {
            ForEach(group.alarms, id: \.id) { alarm in
                alarmRow(alarm, group: group)
            }
            .onDelete { offsets in
                deleteAlarm(at: offsets, in: group)
            }
            
            Button {
                addAlarm(to: group)
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add New Alarm")
                }
                .foregroundColor(.blue)
                .padding(.leading)
            }
            
        } label: {
            HStack {
                if editingGroupID == group.id {
                    TextField("Group name", text: $editingText)
                        .textFieldStyle(.roundedBorder)
                        .focused($isEditing)
                        .onSubmit {
                            commitEdit(group)
                        }
                        .onAppear {
                            isEditing = true
                        }
                        .onChange(of: isEditing) { _, newValue in
                            if !newValue {
                                commitEdit(group)
                            }
                        }
                } else {
                    Text(group.title)
                        .font(.headline)
                        .onTapGesture {
                            editingGroupID = group.id
                            editingText = group.title
                        }
                }
                
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            group.isExpanded.toggle()
                        }
                    }
            }
        }
    }

    
    @ViewBuilder
    private func alarmRow(_ alarm: Alarm, group: GroupAlarm) -> some View {
        Button {
            selectedGroup = group
            selectedAlarm = alarm
        } label: {
            Text(alarm.toString())
                .padding(.leading)
        }
    }
    
    private func addGroup() {
        withAnimation {
            viewModel.addGroup()
        }
    }
    
    private func deleteGroup(at offsets: IndexSet) {
        withAnimation {
            offsets
                .map { groupAlarms[$0] }
                .forEach(viewModel.deleteGroup)
        }
    }
    
    private func deleteAlarm(at offsets: IndexSet, in group: GroupAlarm) {
        withAnimation {
            for index in offsets {
                let alarm = group.alarms[index]
                viewModel.deleteAlarm(alarm)
            }
        }
    }
    
    private func addAlarm(to group: GroupAlarm) {
        withAnimation {
            viewModel.addAlarm(to: group)
        }
    }
    
    private func commitEdit(_ group: GroupAlarm) {
        viewModel.updateTitleGroup(newTitle: editingText, for: group)
        editingGroupID = nil
        editingText = ""
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Alarm.self, inMemory: true)
}
