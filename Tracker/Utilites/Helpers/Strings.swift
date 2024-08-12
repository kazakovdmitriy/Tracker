//
//  Strings.swift
//  Tracker
//
//  Created by Дмитрий on 14.07.2024.
//

import Foundation

enum Strings {
    enum TabBar {
        static func title(for tab: Tabs) -> String {
            switch tab {
            case .trackers: return "Трекеры"
            case .statistics: return "Статистика"
            }
        }
    }
    enum NavBar {
        static let trackers = "Трекеры"
        static let statistics = "Статистика"
    }
    enum NavTitle {
        static let createTrackers = "Создание трекера"
        static let newPractice = "Новая привычка"
        static let newIrregular = "Новое нерегулярное событие"
        static let schedule = "Расписание"
        static let category = "Категория"
    }
    enum CreateTrackerVC {
        static let practiceButton = "Привычка"
        static let irregularEventButton = "Нерегулярные событие"
    }
    enum Onboarding {
        static let first = "Отслеживайте только то, что хотите"
        static let second = "Даже если это не литры воды и йога"
    }
}
