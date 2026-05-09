//
//  Utils.swift
//  GroupAlarmClock
//
//  Created by Tien Dung Doan on 9/5/26.
//

import Foundation

enum WeekdayFormatter {
    
    static let allWeekdays = [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday"
    ]
    
    static func repeatText(from selectedDays: Set<String>) -> String {
        
        if selectedDays.isEmpty {
            return "Never"
        }
        
        let weekdays: Set<String> = [
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday"
        ]
        
        let weekends: Set<String> = [
            "Saturday",
            "Sunday"
        ]
        
        if selectedDays == weekdays {
            return "Weekdays"
        }
        
        if selectedDays == weekends {
            return "Weekends"
        }
        
        if selectedDays.count == 7 {
            return "Every day"
        }
        
        return allWeekdays
            .filter { selectedDays.contains($0) }
            .map(shortName)
            .joined(separator: ", ")
    }
    
    static func shortName(_ day: String) -> String {
        switch day {
        case "Monday": return "Mon"
        case "Tuesday": return "Tue"
        case "Wednesday": return "Wed"
        case "Thursday": return "Thu"
        case "Friday": return "Fri"
        case "Saturday": return "Sat"
        case "Sunday": return "Sun"
        default: return day
        }
    }
}
