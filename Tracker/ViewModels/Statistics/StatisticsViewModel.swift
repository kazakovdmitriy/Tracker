//
//  StatisticsViewModel.swift
//  Tracker
//
//  Created by Дмитрий on 25.08.2024.
//

import Foundation

enum StatisticsName: String {
    case trackersCount
}

protocol StatisticsViewModelProtocol: AnyObject {
    var statistics: [StatisticsName: Int] { get }
    var trackersCount: Int { get }
    
    var onStatisticsUpdate: (() -> Void)? { get set }
    var onTrackerUpdate: ((Bool) -> Void)? { get set }
    
    func fetchTrackers()
}

final class StatisticsViewModel: StatisticsViewModelProtocol {
    var onStatisticsUpdate: (() -> Void)?
    var onTrackerUpdate: ((Bool) -> Void)?
    
    private let trackerRecordStore = TrackerRecordStore.shared
    private let trackerStore = TrackerStore.shared
    
    private(set) var statistics: [StatisticsName: Int] = [:] {
        didSet {
            onStatisticsUpdate?()
        }
    }
    
    private(set) var trackersCount: Int = 0 {
        didSet {
            fetchStatistics()
            onTrackerUpdate?(0 == trackersCount)
        }
    }
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationRecord(_:)), name: .tapPlusButtonOnTracker, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationTracker(_:)), name: .didChangeTrackers, object: nil)
        
        fetchStatistics()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .tapPlusButtonOnTracker, object: nil)
        NotificationCenter.default.removeObserver(self, name: .didChangeTrackers, object: nil)
    }
    
    private func fetchStatistics() {
        statistics[.trackersCount] = trackerRecordStore.countTrackerRecords()
    }
    
    func fetchTrackers() {
        trackersCount = trackerStore.countTracker()
    }
    
    @objc private func handleNotificationRecord(_ notification: Notification) {
        fetchStatistics()
    }
    
    @objc private func handleNotificationTracker(_ notification: Notification) {
        fetchTrackers()
    }
}
