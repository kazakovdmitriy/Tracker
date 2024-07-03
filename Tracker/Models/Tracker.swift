//
//  Tracker.swift
//  Tracker
//
//  Created by Дмитрий on 24.06.2024.
//

import UIKit

enum WeekDays: CaseIterable {
    case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday, None
}

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDays] // Нужно будет сделать структуру для рассписания
}
