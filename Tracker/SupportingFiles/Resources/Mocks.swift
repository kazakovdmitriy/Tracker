//
//  Mocks.swift
//  Tracker
//
//  Created by Дмитрий on 25.08.2024.
//

import UIKit

enum Mocks {
    static let mockTrackerCategories: [TrackerCategory] = [
        TrackerCategory(
            name: "Физическая активность",
            trackers: [
                Tracker(
                    id: UUID(),
                    name: "Упражнение 1",
                    color: UIColor.red,
                    emoji: "🏃",
                    originalCategory: "Физическая активность",
                    completedDate: [Date()],
                    type: .practice,
                    schedule: [.monday, .wednesday, .friday]
                ),
                Tracker(
                    id: UUID(),
                    name: "Упражнение 2",
                    color: UIColor.blue,
                    emoji: "🏋️",
                    originalCategory: "Физическая активность",
                    completedDate: [Date()],
                    type: .practice,
                    schedule: [.tuesday, .thursday]
                )
            ]
        ),
        TrackerCategory(
            name: "Разное",
            trackers: [
                Tracker(
                    id: UUID(),
                    name: "Случайная задача 1",
                    color: UIColor.green,
                    emoji: "📅",
                    originalCategory: "Разное",
                    completedDate: [Date()],
                    type: .irregular,
                    schedule: []
                ),
                Tracker(
                    id: UUID(),
                    name: "Случайная задача 2",
                    color: UIColor.orange,
                    emoji: "🔧",
                    originalCategory: "Разное",
                    completedDate: [Date()],
                    type: .irregular,
                    schedule: []
                )
            ]
        )
    ]
}
