//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Дмитрий on 02.08.2024.
//

import CoreData

final class TrackerCategoryStore: NSObject, NSFetchedResultsControllerDelegate {
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>?
    
    init(context: NSManagedObjectContext = CoreDataService.shared.context) {
        self.context = context
        super.init()
        initializeFetchedResultsController()
    }
    
    func createTrackerRecord(trackerCategory: TrackerCategory) {
        let trackerCategoryEntity = TrackerCategoryCoreData(context: context)
        
        trackerCategoryEntity.name = trackerCategory.name
        
        saveContext()
    }
    
    func fetchedObjects() -> [TrackerCategory] {
        guard let trackerEntities = fetchedResultsController?.fetchedObjects else {
            return []
        }
        
        return trackerEntities.compactMap { try? trackerCategory(from: $0) }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    private func trackerCategory(from trackerCategoryEntity: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let name = trackerCategoryEntity.name else {
            throw TrackerRecordStoreError.decodingErrorInvalidId
        }
        
        return TrackerCategory(name: name, trackers: [])
    }
    
    private func initializeFetchedResultsController() {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
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
}
