//
//  Resources.swift
//  Tracker
//
//  Created by Дмитрий on 20.06.2024.
//

import UIKit

enum R {
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
    }
    
    enum Images {
        enum TabBar {
            static func icon(for tab: Tabs) -> UIImage? {
                switch tab {
                case .trackers: return UIImage(named: "tracker_tab_bar_icon")
                case .statistics: return UIImage(named: "statistics_tab_bar_icon")
                }
            }
        }
    }
    
    enum Fonts {
        static func sfPro(with size: CGFloat, _ weight: UIFont.Weight = .regular) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: weight)
        }
    }
}
