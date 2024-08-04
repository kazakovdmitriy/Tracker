//
//  Set + ext.swift
//  Tracker
//
//  Created by Дмитрий on 04.08.2024.
//

import Foundation

extension Set where Element == TrackerRecord {
    func containtRecord(withId id: UUID) -> Bool {
        return self.contains { $0.id == id }
    }
    
    func containtRecordForDay(withId id: UUID, andDate date: Date) -> Bool {
        return self.contains { $0.id == id && $0.dateComplete.isEqual(date) }
    }
}
