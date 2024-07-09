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
    
    init(id: UUID, dateComplete: Date) {
        self.id = id
        // Обрезаем время у даты
        self.dateComplete = TrackerRecord.stripTime(from: dateComplete)
    }
    
    static private func stripTime(from date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(from: components)!
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(dateComplete)
    }
}
