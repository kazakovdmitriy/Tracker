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

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDays] // Нужно будет сделать структуру для рассписания
}
