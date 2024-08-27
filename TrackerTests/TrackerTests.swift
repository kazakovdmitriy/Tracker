//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Дмитрий on 25.08.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackersViewModelStub: TrackersViewModelProtocol {
    
    static let shared = TrackersViewModelStub()
    
    private init() {}
    
    var onCategoriesUpdated: (() -> Void)?
    
    var categories: [TrackerCategory] = Mocks.mockTrackerCategories
    var showedCategories: [TrackerCategory] = Mocks.mockTrackerCategories
    
    var currentDate: Date = Date()
    
    func fetchCategories() {
        categories = Mocks.mockTrackerCategories
    }
    
    func getHideType() -> HideType {
        return .trackerHide
    }
    
    func updateDate(_ date: Date) {
        return
    }
    
    func addCompletedTracker(for trackerId: UUID) {
        return
    }
    
    func removeCompletedTracker(for trackerId: UUID) {
        return
    }
    
    func pinTracker(forTrackerId id: UUID) {
        return
    }
    
    func getCountOfCompletedTrackers(trackerId: UUID) -> Int {
        return 0
    }
    
    func isTrackerCompleted(trackerId: UUID, date: Date) -> Bool {
        return true
    }
    
    func createTracker(category: String, tracker: Tracker) {
        return
    }
    
    func deleteTracker(with id: UUID) {
        return
    }
    
    func filterAllTrackers() {
        return
    }
    
    func filterTodayTrackers() {
        return
    }
    
    func filterDoneTrackers() {
        return
    }
    
    func filterUnfinishedTrackers() {
        return
    }
    
    
}

final class TrackerTests: XCTestCase {
    
    let viewModel: TrackersViewModelProtocol = TrackersViewModelStub.shared

    func testViewController() {
        let vc = TrackersViewController(viewModel: viewModel)
        
        assertSnapshot(matching: vc, as: .image)
    }
}
