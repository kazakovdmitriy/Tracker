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
    
    func countTrackerRecords() -> Int {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TrackerRecordCoreData.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
            return count
        } catch {
            print("Failed to count TrackerRecord: \(error)")
            return 0
        }
    }
    
    func createTrackerRecord(for trackerId: UUID, dateComplete: Date) {
        // Проверяем, существует ли уже запись с такой датой для данного трекера
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND dateComplete == %@", trackerId as CVarArg, dateComplete as CVarArg)
        
        do {
            let existingRecords = try context.fetch(fetchRequest)
            
            // Если такая запись уже существует, ничего не делаем
            if !existingRecords.isEmpty {
                print("TrackerRecord with date \(dateComplete) for tracker \(trackerId) already exists.")
                return
            }
            
            // Если запись не найдена, создаем новую
            guard let tracker = fetchTrackerById(trackerId: trackerId) else {
                print("Tracker with ID \(trackerId) not found.")
                return
            }
            
            let trackerRecordEntity = TrackerRecordCoreData(context: context)
            trackerRecordEntity.id = UUID()
            trackerRecordEntity.dateComplete = dateComplete
            
            // Связываем новый TrackerRecord с соответствующим Tracker
            tracker.addToRecord_rel(trackerRecordEntity)
            
            saveContext()
            
        } catch {
            print("Failed to check existing TrackerRecord: \(error)")
        }
    }
    
    func deleteTrackerRecord(for trackerId: UUID, on dateComplete: Date) {
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: dateComplete)
        
        // Создаем диапазон дат для поиска записей, которые попадают в этот день
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            print("Failed to calculate end of day.")
            return
        }
        
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "tracker_rel.id == %@ AND dateComplete >= %@ AND dateComplete < %@",
                                                 trackerId as CVarArg,
                                                 startOfDay as CVarArg,
                                                 endOfDay as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            let fetchRecords = try context.fetch(fetchRequest)
            
            if let recordToDelete = fetchRecords.first {
                context.delete(recordToDelete)
                saveContext()
                print("TrackerRecord deleted for Tracker with ID \(trackerId) on \(dateComplete)")
            } else {
                print("No TrackerRecord found for Tracker with ID \(trackerId) on \(dateComplete)")
            }
        } catch {
            print("Failed to fetch or delete TrackerRecord: \(error)")
        }
    }
    
    func fetchedObjects() -> Set<TrackerRecord> {
        guard let trackerEntities = fetchedResultsController?.fetchedObjects else {
            return Set<TrackerRecord>()
        }
        
        return Set(trackerEntities.compactMap { try? trackerRecord(from: $0) })
    }
    
    private func fetchTrackerById(trackerId: UUID) -> TrackerCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", trackerId as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            let trackers = try context.fetch(fetchRequest)
            return trackers.first
        } catch {
            print("Failed to fetch Tracker by ID: \(error)")
            return nil
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
