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
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>?
    
    private init(context: NSManagedObjectContext = CoreDataService.shared.context) {
        self.context = context
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
    
    func fetchCategoriesWithTrackers() -> [TrackerCategory] {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            let trackerCategoryEntities = try context.fetch(fetchRequest)
            return try trackerCategoryEntities.map { try trackerCategoryWithTrackers(from: $0) }
        } catch {
            print("Failed to fetch categories with trackers: \(error)")
            return []
        }
    }
    
    func loadCategoryNames() -> [String] {
        // Создаем запрос для сущности TrackerCategoryCoreData
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        
        // Настройка сортировки по имени категории
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            // Выполняем запрос
            let categories = try context.fetch(fetchRequest)
            
            // Преобразуем результаты в массив строк
            let categoryNames = categories.compactMap { $0.name }
            
            return categoryNames
            
        } catch {
            // Обработка ошибок
            print("Failed to fetch category names: \(error)")
            return []
        }
    }
    
    private func trackerCategoryWithTrackers(from trackerCategoryEntity: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let name = trackerCategoryEntity.name else {
            throw TrackerRecordStoreError.decodingErrorInvalidId
        }
        
        let trackers: [Tracker] = (trackerCategoryEntity.trackers_rel as? Set<TrackerCoreData>)?.compactMap { try? tracker(from: $0) } ?? []
        
        return TrackerCategory(name: name, trackers: trackers)
    }
    
    private func tracker(from trackerEntity: TrackerCoreData) throws -> Tracker {
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
        guard let schedule = trackerEntity.schedule as? [WeekDays] else {
            throw TrackerStoreError.decodingErrorInvalidScedule
        }
        
        let isPractice = trackerEntity.isPractice
        
        return Tracker(id: id,
                       name: name,
                       color: color,
                       emoji: emoji,
                       type: isPractice ? .practice : .irregular,
                       schedule: schedule)
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    private func trackerCategoryAsObject(from trackerCategoryEntity: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let name = trackerCategoryEntity.name else {
            throw TrackerRecordStoreError.decodingErrorInvalidId
        }
        
        return TrackerCategory(name: name, trackers: [])
    }
    
    private func trackerCategoryAsString(from trackerCategoryEntity: TrackerCategoryCoreData) throws -> String {
        guard let name = trackerCategoryEntity.name else {
            throw TrackerRecordStoreError.decodingErrorInvalidId
        }
        
        return name
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
