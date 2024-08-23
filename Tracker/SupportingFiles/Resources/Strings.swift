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
            case .trackers: return NSLocalizedString("tab.tracker", comment: "Text for tracker tab bar")
            case .statistics: return NSLocalizedString("tab.statistics", comment: "Text for statistics tab bar")
            }
        }
    }
    enum NavBar {
        static let trackers = NSLocalizedString("tab.tracker", comment: "Text for tracker tab bar")
        static let statistics = NSLocalizedString("tab.statistics", comment: "Text for statistics tab bar")
    }
    enum NavTitle {
        static let createTrackers = "Создание трекера"
        static let newPractice = "Новая привычка"
        static let newIrregular = "Новое нерегулярное событие"
        static let schedule = "Расписание"
        static let category = "Категория"
        static let createCategory = "Новая категория"
        static let filter = "Фильтры"
    }
    enum Stubs {
        static let emptyTracker = NSLocalizedString("stub.tracker", comment: "Text for empty tracker stub view")
        static let emptyCategory = NSLocalizedString("stub.category", comment: "Text for empty tracker stub view")
        static let nothingFind = NSLocalizedString("stub.find", comment: "Text for empty find stub view")
        static let nothingAnalize = NSLocalizedString("stub.analize", comment: "Text for empty find stub view")
    }
    enum CreateTrackerVC {
        static let practiceButton = "Привычка"
        static let irregularEventButton = "Нерегулярные событие"
    }
    enum Onboarding {
        static let first = "Отслеживайте только то, что хотите"
        static let second = "Даже если это не литры воды и йога"
    }
    enum TrackersVC {
        static let filterButton = NSLocalizedString("tracker.filter.title", comment: "Text for filter button")
        static let searchPlaceHolder = NSLocalizedString("tracker.search.placeholder", comment: "Text for search bar placeholder")
        static let alertMessage = NSLocalizedString("tracker.alertMessage", comment: "Text for delete tracker alert message")
        static let alertBtnDelete = NSLocalizedString("tracker.alertBtnDelete", comment: "Text for delete button")
        static let alertBtnCancle = NSLocalizedString("tracker.alertBtnCancle", comment: "Text for cancle button")
    }
    enum TrackersCardView {
        static let pinBtn = NSLocalizedString("tracker.card.pin", comment: "Text for pin button")
        static let unpinBtn = NSLocalizedString("tracker.card.unpin", comment: "Text for unpin button")
        static let editBtn = NSLocalizedString("tracker.card.edit", comment: "Text for edit button")
        static let deleteBtn = NSLocalizedString("tracker.card.delete", comment: "Text for delete button")
        static let day = NSLocalizedString("tracker.card.day", comment: "Text for one day")
        static let days = NSLocalizedString("tracker.card.days", comment: "Text for many days")
        static let twoDays = NSLocalizedString("tracker.card.twoDays", comment: "Text for two, three, four days")
    }
}
