//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Дмитрий on 21.08.2024.
//

import Foundation

protocol TrackersViewModelProtocol {
    var onCategoriesUpdated: (() -> Void)? { get set }
    var onCompletedTrackersUpdated: (() -> Void)? { get set }
    
    var categories: [TrackerCategory] { get }
    var showedCategories: [TrackerCategory] { get }
    var currentDate: Date { get }
    
    func fetchCategories()
    func updateCompletedTrackers()
    func updateDate(_ date: Date)
    func addCompletedTracker(_ tracker: TrackerRecord)
    func removeCompletedTracker(_ tracker: TrackerRecord)
    func pinTracker(forTrackerId id: UUID)
    func getCountOfCompletedTrackers(date: Date, trackerId: UUID) -> Int
    func isTrackerCompleted(trackerId: UUID, date: Date) -> Bool
    func createTracker(category: String, tracker: Tracker)
}

final class TrackersViewModel: TrackersViewModelProtocol {
    
    // MARK: - Properties
    var onCategoriesUpdated: (() -> Void)?
    var onCompletedTrackersUpdated: (() -> Void)?
    
    private let trackerStore = TrackerStore.shared
    private let trackerRecordStore = TrackerRecordStore.shared
    private let trackerCategoryStore = TrackerCategoryStore.shared
    
    private(set) var categories: [TrackerCategory] = []
    private(set) var showedCategories: [TrackerCategory] = []
    private var internalCompletedTrackers: Set<TrackerRecord> = []
    
    var completedTrackers: Set<TrackerRecord> {
        return internalCompletedTrackers
    }
    
    private(set) var currentDate: Date = Date() {
        didSet {
            updateCategories()
        }
    }
    
    // MARK: - Methods
    func fetchCategories() {
        categories = trackerCategoryStore.fetchCategoriesWithTrackers()
        updateCategories()
    }
    
    func updateCompletedTrackers() {
        internalCompletedTrackers = trackerRecordStore.fetchedObjects()
        onCompletedTrackersUpdated?()
        updateCategories()
    }
    
    func updateDate(_ date: Date) {
        currentDate = date
    }
    
    func addCompletedTracker(_ tracker: TrackerRecord) {
        internalCompletedTrackers.insert(tracker)
        trackerRecordStore.createTrackerRecord(trackerRecord: tracker)
        onCompletedTrackersUpdated?()
    }
    
    func removeCompletedTracker(_ tracker: TrackerRecord) {
        internalCompletedTrackers.remove(tracker)
        try? trackerRecordStore.delete(trackerRecord: tracker)
        onCompletedTrackersUpdated?()
    }
    
    func pinTracker(forTrackerId id: UUID) {
        trackerStore.pinnedTracker(forTrackerId: id)
        fetchCategories()
    }
    
    func isTrackerCompleted(trackerId: UUID, date: Date) -> Bool {
        let trackerRecord = TrackerRecord(id: trackerId, dateComplete: date)
        return internalCompletedTrackers.contains(trackerRecord)
    }
    
    func filterTrackersForToday() -> [TrackerCategory] {
        guard let today = getCurrentWeekDay() else { return [] }
        
        var filteredCategories: [TrackerCategory] = []
        
        for category in categories {
            let filteredTrackers = category.trackers.filter { (tracker: Tracker) in
                switch tracker.type {
                case .practice:
                    return tracker.schedule.contains(today)
                case .irregular:
                    return (
                        !internalCompletedTrackers.containtRecord(withId: tracker.id) ||
                        internalCompletedTrackers.containtRecordForDay(withId: tracker.id, andDate: currentDate)
                    )
                }
            }
            if !filteredTrackers.isEmpty {
                filteredCategories.append(TrackerCategory(name: category.name, trackers: filteredTrackers))
            }
        }
        
        return filteredCategories
    }
    
    func getCountOfCompletedTrackers(date: Date, trackerId: UUID) -> Int {
        var trackerCounts: [UUID: Int] = [:]
        
        for tracker in internalCompletedTrackers {
            if tracker.dateComplete <= date {
                trackerCounts[tracker.id, default: 0] += 1
            }
        }
        
        return trackerCounts[trackerId] ?? 0
    }
    
    func createTracker(category: String, tracker: Tracker) {
        trackerStore.createTracker(tracker: tracker, toCategory: category)
        fetchCategories()
        updateCategories()
    }
    
    private func getCurrentWeekDay() -> WeekDays? {
        let weekDay = Calendar.current.component(.weekday, from: currentDate)
        
        switch weekDay {
        case 1: return .sunday
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        default: return nil
        }
    }
    
    private func updateCategories() {
        showedCategories = filterTrackersForToday()
        onCategoriesUpdated?()
    }
}
