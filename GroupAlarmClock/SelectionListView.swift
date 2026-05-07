//
//  SelectionListView.swift
//  GroupAlarmClock
//
//  Created by Tien Dung Doan on 7/5/26.
//

import SwiftUI

enum SelectionType {
    case weekdays
    case sounds
}
struct SelectionListView: View {
    let title: String
    var selectionType: SelectionType
    var items: [String] {
        switch selectionType {
        case .weekdays:
            return weekdays
        case .sounds:
            return sounds
        }
    }

    @Binding var selectedItem: String

    var body: some View {
        List(items, id: \.self) { item in
            Button {
                selectedItem = item
            } label: {
                HStack {
                    Text(item)

                    Spacer()

                    if item == selectedItem {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.blue)
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    let weekdays = [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday"
    ]

    let sounds = [
        "Default",
        "Radar",
        "Beacon",
        "Chimes",
        "Signal"
    ]
}

//#Preview {
//    SelectionListView()
//}
