//
//  Date + ext.swift
//  Tracker
//
//  Created by Дмитрий on 04.08.2024.
//

import Foundation

extension Date {    
    func isEqual(_ date: Date = Date()) -> Bool {
        let calendar = Calendar.current

        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let selfComponents = calendar.dateComponents([.year, .month, .day], from: self)

        return calendar.date(from: selfComponents)! == calendar.date(from: dateComponents)!
    }
}
