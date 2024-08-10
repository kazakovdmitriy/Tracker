//
//  Tracker.swift
//  Tracker
//
//  Created by Дмитрий on 24.06.2024.
//

import UIKit

enum TrackerType {
    case practice
    case irregular
}

struct Tracker: Equatable {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let type: TrackerType
    let schedule: [WeekDays]
    
    static func == (lhs: Tracker, rhs: Tracker) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.color == rhs.color &&
        lhs.emoji == rhs.emoji &&
        lhs.type == rhs.type &&
        lhs.schedule == rhs.schedule
    }
}
