//
//  Tracker.swift
//  Tracker
//
//  Created by Дмитрий on 24.06.2024.
//

import UIKit

enum WeekDays: CaseIterable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday, none
}

struct Tracker: Equatable {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDays] // Нужно будет сделать структуру для рассписания
    
    static func == (lhs: Tracker, rhs: Tracker) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.color == rhs.color &&
        lhs.emoji == rhs.emoji &&
        lhs.schedule == rhs.schedule
    }
}
