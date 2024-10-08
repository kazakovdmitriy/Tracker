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

enum HideType {
    case filterHide
    case trackerHide
    case showTracker
}

protocol TrackersViewModelProtocol {
    var onCategoriesUpdated: (() -> Void)? { get set }
    
    var categories: [TrackerCategory] { get }
    var showedCategories: [TrackerCategory] { get }
    var currentDate: Date { get }
    
    func fetchCategories()
    func getHideType() -> HideType
    func getTracker(by id: UUID) -> Tracker?
    func updateDate(_ date: Date)
    func addCompletedTracker(for trackerId: UUID)
    func removeCompletedTracker(for trackerId: UUID)
    func pinTracker(forTrackerId id: UUID)
    func getCountOfCompletedTrackers(trackerId: UUID) -> Int
    func isTrackerCompleted(trackerId: UUID, date: Date) -> Bool
    func createTracker(category: String, tracker: Tracker)
    func updateTracker(category: String, tracker: Tracker)
    func deleteTracker(with id: UUID)
    func filterAllTrackers()
    func filterTodayTrackers()
    func filterDoneTrackers()
    func filterUnfinishedTrackers()
}

final class TrackersViewModel: TrackersViewModelProtocol {
    
    // MARK: - Properties
    
    var onCategoriesUpdated: (() -> Void)?
    
    private let trackerStore = TrackerStore.shared
    private let trackerRecordStore = TrackerRecordStore.shared
    private let trackerCategoryStore = TrackerCategoryStore.shared
    
    private(set) var categories: [TrackerCategory] = []
    private(set) var showedCategories: [TrackerCategory] = []
    
    private var currentFilter: TrackerFilter = .all
    
    private(set) var currentDate: Date = {
        let calendar = Calendar.current
        return calendar.startOfDay(for: Date())
    }() {
        didSet {
            updateCategories()
        }
    }
    
    // MARK: - Methods
    
    func fetchCategories() {
        categories = trackerCategoryStore.fetchCategoriesWithAllTrackersAndRecords()
        updateCategories()
    }
    
    func getHideType() -> HideType {
        let hasTracker = hasTrackersToday()
        
        if hasTracker && showedCategories.isEmpty {
            return .filterHide
        } else if showedCategories.isEmpty {
            return .trackerHide
        } else {
            return .showTracker
        }
    }
    
    func getTracker(by id: UUID) -> Tracker? {
        return categories
            .flatMap { $0.trackers }
            .first { $0.id == id }
    }
    
    private func hasTrackersToday() -> Bool {
        guard let today = WeekDays.getCurrentWeekDay(for: currentDate) else { return false }
        
        return categories
            .flatMap { $0.trackers }
            .contains { $0.schedule.contains(today) }
    }
    
    func updateDate(_ date: Date) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        
        currentDate = startOfDay
    }
    
    func addCompletedTracker(for trackerId: UUID) {
        trackerRecordStore.createTrackerRecord(for: trackerId, dateComplete: currentDate)
        NotificationCenter.default.post(name: .tapPlusButtonOnTracker, object: nil)
        fetchCategories()
    }
    
    func removeCompletedTracker(for trackerId: UUID) {
        trackerRecordStore.deleteTrackerRecord(for: trackerId, on: currentDate)
        NotificationCenter.default.post(name: .tapPlusButtonOnTracker, object: nil)
        fetchCategories()
    }
    
    func pinTracker(forTrackerId id: UUID) {
        trackerStore.pinnedTracker(forTrackerId: id)
        fetchCategories()
    }
    
    func isTrackerCompleted(trackerId: UUID, date: Date) -> Bool {
        guard let tracker = categories
            .flatMap({ $0.trackers })
            .first(where: { $0.id == trackerId }) else {
                return false
        }
        
        return tracker.completedDate.contains(date)
    }
    
    func getCountOfCompletedTrackers(trackerId: UUID) -> Int {
        guard let tracker = categories
            .flatMap({ $0.trackers })
            .first(where: { $0.id == trackerId }) else {
                return 0
        }
        
        let count = tracker.completedDate.filter { $0 <= currentDate }.count
        
        return count
    }
    
    func filterTrackersForToday() -> [TrackerCategory] {
        guard let today = WeekDays.getCurrentWeekDay(for: currentDate) else { return [] }
        
        return categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                return shouldIncludeTracker(tracker, for: today)
            }
            return filteredTrackers.isEmpty ? nil : TrackerCategory(name: category.name, trackers: filteredTrackers)
        }
    }
    
    func createTracker(category: String, tracker: Tracker) {
        trackerStore.createTracker(tracker: tracker, toCategory: category)
        fetchCategories()
    }
    
    func updateTracker(category: String, tracker: Tracker) {
        trackerStore.updateTracker(updatedTracker: tracker)
        fetchCategories()
    }
    
    func deleteTracker(with id: UUID) {
        trackerStore.deleteTracker(with: id)
        fetchCategories()
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
        updateCategories()
    }
    
    func filterUnfinishedTrackers() {
        currentFilter = .unfinished
        updateCategories()
    }
    
    private func shouldIncludeTracker(_ tracker: Tracker, for today: WeekDays) -> Bool {
        switch currentFilter {
        case .all, .today:
            return filterAllOrToday(tracker, for: today)
        case .done:
            return filterDone(tracker, for: today)
        case .unfinished:
            return filterUnfinished(tracker, for: today)
        }
    }

    private func filterAllOrToday(_ tracker: Tracker, for today: WeekDays) -> Bool {
        switch tracker.type {
        case .practice:
            return tracker.schedule.contains(today)
        case .irregular:
            return tracker.completedDate.isEmpty || tracker.completedDate.contains(currentDate)
        }
    }

    private func filterDone(_ tracker: Tracker, for today: WeekDays) -> Bool {
        switch tracker.type {
        case .practice:
            return tracker.schedule.contains(today) && tracker.completedDate.contains(currentDate)
        case .irregular:
            return tracker.completedDate.contains(currentDate)
        }
    }

    private func filterUnfinished(_ tracker: Tracker, for today: WeekDays) -> Bool {
        switch tracker.type {
        case .practice:
            return tracker.schedule.contains(today) && !tracker.completedDate.contains(currentDate)
        case .irregular:
            return tracker.completedDate.isEmpty
        }
    }
    
    private func updateCategories() {
        showedCategories = filterTrackersForToday()
        onCategoriesUpdated?()
    }
}
