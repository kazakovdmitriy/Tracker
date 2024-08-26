//
//  WeekDays.swift
//  Tracker
//
//  Created by Дмитрий on 19.07.2024.
//

import Foundation

enum WeekDays: CaseIterable, Codable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday, none
    
    static func getCurrentWeekDay(for date: Date) -> WeekDays? {
        let weekDay = Calendar.current.component(.weekday, from: date)
        
        switch weekDay {
        case 1: return .sunday
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        default: return nil
        }
    }
}
