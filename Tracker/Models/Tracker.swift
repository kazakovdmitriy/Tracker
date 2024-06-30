//
//  Tracker.swift
//  Tracker
//
//  Created by Дмитрий on 24.06.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [Date] // Нужно будет сделать структуру для рассписания
}
