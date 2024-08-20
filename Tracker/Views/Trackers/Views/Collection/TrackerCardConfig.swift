//
//  TrackerCardConfig.swift
//  Tracker
//
//  Created by Дмитрий on 14.07.2024.
//

import UIKit

struct TrackerCardConfig {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let category: String
    let days: Int
    let isDone: Bool
    let plusDelegate: TrackerCardViewProtocol
    let date: Date
}
