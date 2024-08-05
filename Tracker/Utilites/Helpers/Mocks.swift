//
//  Mocks.swift
//  Tracker
//
//  Created by Дмитрий on 11.07.2024.
//

import Foundation

enum Mocks {
    static let categories: [TrackerCategory] = [
        TrackerCategory(name: "Домашний уют", trackers: [
            Tracker(id: UUID(uuidString: "B81135FC-F8FE-4956-A19A-BD9F9F2086E3") ?? UUID(),
                    name: "Поливать растения",
                    color: .ypColorSelection5,
                    emoji: "❤️",
                    type: .practice,
                    schedule: [.monday]),
            Tracker(id: UUID(uuidString: "BDE6641A-1AA1-4B3B-87C3-39C951548031") ?? UUID(),
                    name: "Кошка заслонила камеру на созвоне",
                    color: .ypColorSelection3,
                    emoji: "😹",
                    type: .practice,
                    schedule: [.monday, .friday, .sunday, .saturday]),
            Tracker(id: UUID(uuidString: "8FE2AE56-98F5-496B-8FF9-0ECAA4C477DA") ?? UUID(),
                    name: "Бабушка прислала открытку в ватсапе",
                    color: .ypColorSelection11,
                    emoji: "🌸",
                    type: .practice,
                    schedule: [.monday, .tuesday])
        ]),
        TrackerCategory(name: "Вторая категория", trackers: [
            Tracker(id: UUID(uuidString: "A5EF31C6-A9CB-4E24-B14A-0619A253B739") ?? UUID(),
                    name: "Поливать растения",
                    color: .ypColorSelection5,
                    emoji: "❤️",
                    type: .practice,
                    schedule: [.monday]),
            Tracker(id: UUID(uuidString: "5F8AFE7A-53A4-4E71-BD9B-3DC7BDC5F4D4") ?? UUID(),
                    name: "Кошка заслонила камеру на созвоне",
                    color: .ypColorSelection3,
                    emoji: "😹",
                    type: .practice,
                    schedule: [.monday, .sunday, .saturday]),
            Tracker(id: UUID(uuidString: "F1406143-AC13-493C-BA82-8CF9FD7389B2") ?? UUID(),
                    name: "Бабушка прислала открытку в ватсапе",
                    color: .ypColorSelection11,
                    emoji: "🌸",
                    type: .practice,
                    schedule: [.monday, .tuesday, .friday])
        ])
    ]
    
    static let calendar = Calendar.current
    
    static func createDate(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date {
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            dateComponents.hour = hour
            dateComponents.minute = minute
            dateComponents.second = second
            
            return calendar.date(from: dateComponents) ?? Date()
        }
    
    static let completedTrackers: Set<TrackerRecord> = [
            TrackerRecord(id: UUID(uuidString: "A5EF31C6-A9CB-4E24-B14A-0619A253B739") ?? UUID(),
                          dateComplete: createDate(year: 2024, month: 7, day: 1, hour: 10, minute: 44, second: 0)),
            TrackerRecord(id: UUID(uuidString: "A5EF31C6-A9CB-4E24-B14A-0619A253B739") ?? UUID(),
                          dateComplete: createDate(year: 2024, month: 7, day: 2, hour: 10, minute: 44, second: 0)),
            TrackerRecord(id: UUID(uuidString: "A5EF31C6-A9CB-4E24-B14A-0619A253B739") ?? UUID(),
                          dateComplete: createDate(year: 2024, month: 7, day: 3, hour: 10, minute: 44, second: 0)),
            TrackerRecord(id: UUID(uuidString: "A5EF31C6-A9CB-4E24-B14A-0619A253B739") ?? UUID(),
                          dateComplete: createDate(year: 2024, month: 7, day: 4, hour: 10, minute: 44, second: 0)),
            TrackerRecord(id: UUID(uuidString: "F1406143-AC13-493C-BA82-8CF9FD7389B2") ?? UUID(),
                          dateComplete: createDate(year: 2024, month: 7, day: 4, hour: 10, minute: 44, second: 0)),
            TrackerRecord(id: UUID(uuidString: "F1406143-AC13-493C-BA82-8CF9FD7389B2") ?? UUID(),
                          dateComplete: createDate(year: 2024, month: 7, day: 5, hour: 10, minute: 44, second: 0)),
            TrackerRecord(id: UUID(uuidString: "F1406143-AC13-493C-BA82-8CF9FD7389B2") ?? UUID(),
                          dateComplete: createDate(year: 2024, month: 7, day: 1, hour: 10, minute: 44, second: 0)),
        ]
}
