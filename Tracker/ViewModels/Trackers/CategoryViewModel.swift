//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Дмитрий on 13.08.2024.
//

import Foundation

final class CategoryViewModel {
    
    // MARK: - Public properties
    var selectedCategoryIndex: Int?
    
    // MARK: - Closures for Binding
    var onCategoriesUpdated: (() -> Void)?
    var onCategorySelected: ((String) -> Void)?
    var onShowStubView: ((Bool) -> Void)?
    
    // MARK: - Private properties
    private let trackerCategoryStore = TrackerCategoryStore.shared
    private(set) var categories: [String] = []
    
    // MARK: - Initializer
    init() {
        loadCategories()
    }
    
    // MARK: - Public Methods
    func loadCategories() {
        categories = trackerCategoryStore.loadCategoryNames()
        onCategoriesUpdated?()
        onShowStubView?(categories.isEmpty)
    }
    
    func addCategory(_ category: String) {
        trackerCategoryStore.createTrackerRecord(trackerCategory: TrackerCategory(name: category, trackers: []))
        loadCategories()
    }
    
    func selectCategory(at index: Int) {
        selectedCategoryIndex = index
        onCategorySelected?(categories[index])
    }
}
