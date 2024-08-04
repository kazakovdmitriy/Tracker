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
}

final class TrackerStore: NSObject, NSFetchedResultsControllerDelegate {
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    private let transformer = DaysValueTransformer()
    
    init(context: NSManagedObjectContext = CoreDataService.shared.context) {
        self.context = context
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
    
    func createTracker(tracker: Tracker) {
        let trackerEntity = TrackerCoreData(context: context)
        
        trackerEntity.id = tracker.id
        trackerEntity.name = tracker.name
        trackerEntity.emoji = tracker.emoji
        trackerEntity.color = tracker.color
        trackerEntity.isPractice = tracker.type == .practice ? true : false
        trackerEntity.schedule = tracker.schedule as NSObject
        
        saveContext()
    }
    
    func fetchedObjects() -> [Tracker] {
        guard let trackerEntities = fetchedResultsController?.fetchedObjects else {
            return []
        }
        
        return trackerEntities.compactMap { try? tracker(from: $0) }
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
        
        let isPratice = trackerEntity.isPractice
        
        return Tracker(id: id,
                       name: name,
                       color: color,
                       emoji: emoji,
                       type: isPratice ? .practice : .irregular,
                       schedule: schedule)
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}

