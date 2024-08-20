//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Дмитрий on 31.07.2024.
//

import CoreData

enum TrackerRecordStoreError: Error {
    case decodingErrorInvalidId
    case decodingErrorInvalidDateComplete
    case fetchError
}

final class TrackerRecordStore: NSObject, NSFetchedResultsControllerDelegate {
    
    static let shared = TrackerRecordStore()
    
    private let context: NSManagedObjectContext = CoreDataService.shared.context
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>?
    
    private override init() {
        super.init()
        initializeFetchedResultsController()
    }
    
    func createTrackerRecord(trackerRecord: TrackerRecord) {
        let trackerRecordEntity = TrackerRecordCoreData(context: context)
        
        trackerRecordEntity.id = trackerRecord.id
        trackerRecordEntity.dateComplete = trackerRecord.dateComplete
        
        saveContext()
    }
    
    func fetchedObjects() -> Set<TrackerRecord> {
        guard let trackerEntities = fetchedResultsController?.fetchedObjects else {
            return Set<TrackerRecord>()
        }
        
        return Set(trackerEntities.compactMap { try? trackerRecord(from: $0) })
    }
    
    func delete(trackerRecord: TrackerRecord) throws {
        
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND dateComplete == %@",
                                             trackerRecord.id as CVarArg,
                                             trackerRecord.dateComplete as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            if let entity1 = results.first {
                context.delete(entity1)
                saveContext()
            }
        } catch {
            print("Failed to fetch TrackerRecord: \(error)")
            throw TrackerRecordStoreError.fetchError
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    private func trackerRecord(from trackerRecordEntity: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let id = trackerRecordEntity.id else {
            throw TrackerRecordStoreError.decodingErrorInvalidId
        }
        guard let dateComplete = trackerRecordEntity.dateComplete else {
            throw TrackerRecordStoreError.decodingErrorInvalidDateComplete
        }
        
        return TrackerRecord(id: id, dateComplete: dateComplete)
    }
    
    private func initializeFetchedResultsController() {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
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
