//
//  CollectionViewDelegate.swift
//  Tracker
//
//  Created by Дмитрий on 02.07.2024.
//

import UIKit

final class TrackerCollectionViewDelegate: NSObject {
    var categories: [TrackerCategory] = []
    var completedTrackers: Set<TrackerRecord> = []
    var currentDate: Date?
}

extension TrackerCollectionViewDelegate: UICollectionViewDelegate {
    
}

extension TrackerCollectionViewDelegate: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCardView.reuseIdentifier,
            for: indexPath) as? TrackerCardView
        else {
            return UICollectionViewCell()
        }
        
        let item = categories[indexPath.section].trackers[indexPath.row]
        let days = countTrackersDays(date: currentDate ?? Date(), trackerId: item.id)
        let currentTrackerRecord = TrackerRecord(id: item.id, dateComplete: currentDate ?? Date())
        let isDone = completedTrackers.contains(currentTrackerRecord)
        
        let config = TrackerCardConfig(
            id: item.id,
            title: item.name,
            color: item.color,
            emoji: item.emoji,
            days: days,
            isDone: isDone,
            plusDelegate: self,
            date: currentDate ?? Date()
        )
        
        cell.configure(config: config)
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Unexpected element kind")
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerSectionHeader.reuseIdentifier,
            for: indexPath) as? TrackerSectionHeader
        else {
            return UICollectionReusableView()
        }
        
        header.setText(categories[indexPath.section].name)
        return header
    }
}

extension TrackerCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = (collectionView.layer.frame.width - 10) / 2
        
        return CGSize(width: cellWidth, height: 148)
    }
    
    // Минимальное межстрочное расстояние
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // Минимальное межколоночное расстояние
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

private extension TrackerCollectionViewDelegate {
    func countTrackersDays(date: Date, trackerId: UUID) -> Int {
        var trackerCounts: [UUID: Int] = [:]
        
        for tracker in completedTrackers {
            if tracker.dateComplete <= date {
                trackerCounts[tracker.id, default: 0] += 1
            }
        }
        
        return trackerCounts[trackerId] ?? 0
    }
}

extension TrackerCollectionViewDelegate: TrackerCardViewProtocol {
    func didTapPlusButton(with id: UUID, isActive: Bool) {
        
        guard let currentDate = currentDate else { return }
        
        if currentDate > Date() {
            print("Нельзя отмечать будущие трекеры")
        } else {
            print("Нажата кнопка плюс на трекере: \(id) в состоянии \(isActive) для даты: \(currentDate)")
            let newTrackerRecord = TrackerRecord(id: id, dateComplete: currentDate)
            
            if !isActive {
                if let newTrackerRecord = completedTrackers.remove(newTrackerRecord) {
                    print("\(newTrackerRecord) was removed.")
                } else {
                    print("Banana not found in the set.")
                }
            } else {
                completedTrackers.insert(newTrackerRecord)
                print("\(newTrackerRecord) was add.")
            }
        }
    }
}
