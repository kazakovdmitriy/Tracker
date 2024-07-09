//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Дмитрий on 24.06.2024.
//

import Foundation

struct TrackerCategory: Equatable {
    let name: String
    let trackers: [Tracker]
    
    static func == (lhs: TrackerCategory, rhs: TrackerCategory) -> Bool {
        return lhs.name == rhs.name && lhs.trackers == rhs.trackers
    }
}
