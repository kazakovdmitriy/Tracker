//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Дмитрий on 21.08.2024.
//

import Foundation

enum TrackerFilter {
    case all
    case today
    case done
    case unfinished
}

protocol TrackersViewModelProtocol {
    var onCategoriesUpdated: (() -> Void)? { get set }
    var onCompletedTrackersUpdated: (() -> Void)? { get set }
    
    var categories: [TrackerCategory] { get }
    var showedCategories: [TrackerCategory] { get }
    var currentDate: Date { get }
    
    func fetchCategories()
    func updateCompletedTrackers()
    func updateDate(_ date: Date)
    func addCompletedTracker(for trackerId: UUID, dateComplete: Date)
    func removeCompletedTracker(for trackerId: UUID, on dateComplete: Date)
    func pinTracker(forTrackerId id: UUID)
    func getCountOfCompletedTrackers(trackerId: UUID) -> Int
    func isTrackerCompleted(trackerId: UUID, date: Date) -> Bool
    func createTracker(category: String, tracker: Tracker)
    func deleteTracker(with id: UUID)
    func filterAllTrackers()
    func filterTodayTrackers()
    func filterDoneTrackers()
    func filterUnfinishedTrackers()
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
    
    private var currentFilter: TrackerFilter = .all
    
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
        categories = trackerCategoryStore.fetchCategoriesWithAllTrackersAndRecords()
        updateCategories()
    }
    
    func deleteTracker(with id: UUID) {
        trackerStore.deleteTracker(with: id)
        fetchCategories()
        updateCategories()
        onCategoriesUpdated?()
    }
    
    func updateCompletedTrackers() {
        internalCompletedTrackers = trackerRecordStore.fetchedObjects()
        onCompletedTrackersUpdated?()
        updateCategories()
    }
    
    func updateDate(_ date: Date) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        
        currentDate = startOfDay
        applyCurrentFilter()
    }
    
    func addCompletedTracker(for trackerId: UUID, dateComplete: Date) {
        trackerRecordStore.createTrackerRecord(for: trackerId, dateComplete: dateComplete)
        fetchCategories()
        updateCategories()
    }
    
    func removeCompletedTracker(for trackerId: UUID, on dateComplete: Date) {
        trackerRecordStore.deleteTrackerRecord(for: trackerId, on: dateComplete)
        fetchCategories()
        updateCategories()
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
    
    func getCountOfCompletedTrackers(trackerId: UUID) -> Int {
        
        guard let tracker = categories.flatMap({ $0.trackers }).first(where: { $0.id == trackerId }) else {
            return 0
        }
        
        // Фильтруем записи, связанные с найденным трекером, по условию
        let count = tracker.completedDate.filter { $0 <= currentDate }.count
        
        return count
    }
    
    func createTracker(category: String, tracker: Tracker) {
        trackerStore.createTracker(tracker: tracker, toCategory: category)
        fetchCategories()
        updateCategories()
    }
    
    // MARK: - Methods for Filtering
    func applyCurrentFilter() {
        switch currentFilter {
        case .all:
            filterAllTrackers()
        case .today:
            filterTodayTrackers()
        case .done:
            filterDoneTrackers()
        case .unfinished:
            filterUnfinishedTrackers()
        }
    }
    
    func filterAllTrackers() {
        currentFilter = .all
        updateCategories()
    }
    
    func filterTodayTrackers() {
        currentFilter = .today
        currentDate = Date()
        updateCategories()
    }
    
    func filterDoneTrackers() {
        currentFilter = .done
        showedCategories = categories.map { category in
            let filteredTrackers = category.trackers.filter { tracker in
                return isTrackerCompleted(trackerId: tracker.id, date: currentDate)
            }
            return TrackerCategory(name: category.name, trackers: filteredTrackers)
        }.filter { $0.trackers.isEmpty }
        onCategoriesUpdated?()
    }
    
    func filterUnfinishedTrackers() {
        currentFilter = .unfinished
        showedCategories = categories.map { category in
            let filteredTrackers = category.trackers.filter { tracker in
                return !isTrackerCompleted(trackerId: tracker.id, date: currentDate)
            }
            return TrackerCategory(name: category.name, trackers: filteredTrackers)
        }.filter { !$0.trackers.isEmpty }
        onCategoriesUpdated?()
    }
    
    private func startOfDay(for date: Date) -> Date {
        return Calendar.current.startOfDay(for: date)
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
