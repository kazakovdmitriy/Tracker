//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Дмитрий on 02.08.2024.
//

import CoreData
import UIKit

final class TrackerCategoryStore: NSObject, NSFetchedResultsControllerDelegate {
    
    static let shared = TrackerCategoryStore()
    
    private let context: NSManagedObjectContext = CoreDataService.shared.context
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>?
    
    private override init() {
        super.init()
        initializeFetchedResultsController()
    }
    
    func createTrackerRecord(trackerCategory: TrackerCategory) {
        
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", trackerCategory.name)
        
        do {
            let existingCategories = try context.fetch(fetchRequest)
            if existingCategories.isEmpty {
                let trackerCategoryEntity = TrackerCategoryCoreData(context: context)
                
                trackerCategoryEntity.id = UUID()
                trackerCategoryEntity.name = trackerCategory.name
                
                saveContext()
            } else {
                print("Category with name \(trackerCategory.name) already exists.")
            }
        } catch {
            print("Failed to check for existing category: \(error)")
        }
    }
    
    func loadCategoryNames() -> [String] {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "name != %@", "Закрепленные")
        
        do {
            let categories = try context.fetch(fetchRequest)
            let categoryNames = categories.compactMap { $0.name }
            
            return categoryNames
        } catch {
            print("Failed to fetch category names: \(error)")
            return []
        }
    }
    
    func checkAndCreatePinCategory() {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        
        let categoryName = "Закрепленные"
        
        fetchRequest.predicate = NSPredicate(format: "name == %@", categoryName)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if results.isEmpty {
                let newRecord = TrackerCategoryCoreData(context: context)
                newRecord.id = UUID()
                newRecord.name = categoryName
                
                saveContext()
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    func fetchCategoriesWithAllTrackersAndRecords() -> [TrackerCategory] {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        do {
            let trackerCategoryEntities = try context.fetch(fetchRequest)
            return try trackerCategoryEntities.map { try trackerCategoryWithAllTrackersAndRecords(from: $0) }
        } catch {
            print("Failed to fetch categories with all trackers and records: \(error)")
            return []
        }
    }

    private func trackerCategoryWithAllTrackersAndRecords(from trackerCategoryEntity: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let name = trackerCategoryEntity.name else {
            throw TrackerRecordStoreError.decodingErrorInvalidId
        }
        
        let trackers: [Tracker] = (trackerCategoryEntity.trackers_rel as? Set<TrackerCoreData>)?.compactMap { trackerEntity in
            return try? trackerWithRecords(from: trackerEntity)
        }.sorted { $0.name < $1.name } ?? []
        
        return TrackerCategory(name: name, trackers: trackers)
    }

    private func trackerWithRecords(from trackerEntity: TrackerCoreData) throws -> Tracker {
        guard let id = trackerEntity.id else {
            throw TrackerStoreError.decodingErrorInvalidId
        }
        guard let name = trackerEntity.name else {
            throw TrackerStoreError.decodingErrorInvalidName
        }
        guard let color = trackerEntity.color as? UIColor else {
            throw TrackerStoreError.decodingErrorInvalidColor
        }
        guard let emoji = trackerEntity.emoji else {
            throw TrackerStoreError.decodingErrorInvalidEmoji
        }
        guard let originalCategory = trackerEntity.original_category else {
            throw TrackerStoreError.decodingErrorInvalidOriginalCategory
        }
        guard let schedule = trackerEntity.schedule as? [WeekDays] else {
            throw TrackerStoreError.decodingErrorInvalidScedule
        }
        
        let isPractice = trackerEntity.isPractice
        
        let recordDates: Set<Date> = Set((trackerEntity.record_rel as? Set<TrackerRecordCoreData>)?.compactMap { recordEntity in
            return try? recordDate(from: recordEntity)
        } ?? [])
        
        return Tracker(id: id,
                       name: name,
                       color: color,
                       emoji: emoji,
                       originalCategory: originalCategory,
                       completedDate: recordDates,
                       type: isPractice ? .practice : .irregular,
                       schedule: schedule)
    }

    private func recordDate(from trackerRecordEntity: TrackerRecordCoreData) throws -> Date {
        guard let dateComplete = trackerRecordEntity.dateComplete else {
            throw TrackerRecordStoreError.decodingErrorInvalidDateComplete
        }
        
        let calendar = Calendar.current
        return calendar.startOfDay(for: dateComplete)
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    private func initializeFetchedResultsController() {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("Failed to initialize FetchedResultsController: \(error)")
        }
    }
}
