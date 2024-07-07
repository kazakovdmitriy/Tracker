//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Дмитрий on 24.06.2024.
//

import Foundation

struct TrackerRecord: Hashable {
    let id: UUID
    let dateComplete: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(dateComplete)
    }
}
