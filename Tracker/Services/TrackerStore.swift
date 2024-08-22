//
//  TrackerStore.swift
//  Tracker
//
//  Created by Дмитрий on 18.07.2024.
//

import UIKit
import CoreData

enum TrackerStoreError: Error {
    case decodingErrorInvalidId
    case decodingErrorInvalidName
    case decodingErrorInvalidColor
    case decodingErrorInvalidEmoji
    case decodingErrorInvalidScedule
    case decodingErrorInvalidOriginalCategory
}

final class TrackerStore: NSObject, NSFetchedResultsControllerDelegate {
    
    static let shared = TrackerStore()
    
    private let context: NSManagedObjectContext = CoreDataService.shared.context
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    private let transformer = DaysValueTransformer()
    
    private override init() {
        super.init()
        initializeFetchedResultsController()
    }
    
    private func initializeFetchedResultsController() {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    func createTracker(tracker: Tracker, toCategory categoryName: String) {
        let trackerEntity = TrackerCoreData(context: context)
        
        trackerEntity.id = tracker.id
        trackerEntity.name = tracker.name
        trackerEntity.emoji = tracker.emoji
        trackerEntity.original_category = tracker.originalCategory
        trackerEntity.color = tracker.color
        trackerEntity.isPractice = tracker.type == .practice ? true : false
        trackerEntity.schedule = tracker.schedule as NSObject
        
        // Поиск категории
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", categoryName)
        
        var trackerCategoryEntity: TrackerCategoryCoreData
        do {
            let fetchedCategories = try context.fetch(fetchRequest)
            if let existingCategory = fetchedCategories.first {
                trackerCategoryEntity = existingCategory
                trackerCategoryEntity.addToTrackers_rel(trackerEntity)
            }
        } catch {
            print("Failed to fetch category: \(error)")
            return
        }
        
        saveContext()
    }
    
    func pinnedTracker(forTrackerId trackerId: UUID) {
        // Поиск трекера по ID
        let trackerFetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        trackerFetchRequest.predicate = NSPredicate(format: "id == %@", trackerId as CVarArg)
        
        do {
            let fetchedTrackers = try context.fetch(trackerFetchRequest)
            guard let trackerEntity = fetchedTrackers.first else {
                print("Tracker not found with ID: \(trackerId)")
                return
            }
            
            // Определяем новую категорию
            let newCategoryName: String
            if trackerEntity.category_rel?.name == "Закрепленные" {
                newCategoryName = trackerEntity.original_category ?? ""
            } else {
                newCategoryName = "Закрепленные"
            }
            
            // Поиск новой категории
            let categoryFetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
            categoryFetchRequest.predicate = NSPredicate(format: "name == %@", newCategoryName)
            
            let fetchedCategories = try context.fetch(categoryFetchRequest)
            guard let newCategoryEntity = fetchedCategories.first else {
                print("Category not found with name: \(newCategoryName)")
                return
            }
            
            // Удаление трекера из предыдущей категории
            if let oldCategoryEntity = trackerEntity.category_rel {
                oldCategoryEntity.removeFromTrackers_rel(trackerEntity)
            }
            
            // Добавление трекера в новую категорию
            newCategoryEntity.addToTrackers_rel(trackerEntity)
            
            print("Tracker with ID \(trackerId) moved to category \(newCategoryName)")
            saveContext()
            
        } catch {
            print("Failed to update tracker category: \(error)")
        }
    }
    
    func deleteTracker(with id: UUID) {
        let trackerFetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        trackerFetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let objects = try context.fetch(trackerFetchRequest)
            
            for object in objects {
                context.delete(object)
            }
            
            try context.save()
        } catch {
            print("Ошибка при удалении объекта: \(error)")
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}

