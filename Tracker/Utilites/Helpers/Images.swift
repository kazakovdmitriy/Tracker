//
//  Images.swift
//  Tracker
//
//  Created by Дмитрий on 14.07.2024.
//

import UIKit

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
