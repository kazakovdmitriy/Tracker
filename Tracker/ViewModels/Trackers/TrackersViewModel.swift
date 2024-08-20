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
    var completedTrackers: Set<TrackerRecord> { get }
    var currentDate: Date { get }
    
    func fetchCategories()
    func updateCompletedTrackers()
    func updateDate(_ date: Date)
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
    private(set) var completedTrackers: Set<TrackerRecord> = []
    
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
        completedTrackers = trackerRecordStore.fetchedObjects()
        onCompletedTrackersUpdated?()
        updateCategories()
    }
    
    func updateDate(_ date: Date) {
        currentDate = date
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
                        !completedTrackers.containtRecord(withId: tracker.id) ||
                        completedTrackers.containtRecordForDay(withId: tracker.id, andDate: currentDate)
                    )
                }
            }
            if !filteredTrackers.isEmpty {
                filteredCategories.append(TrackerCategory(name: category.name, trackers: filteredTrackers))
            }
        }
        
        return filteredCategories
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
