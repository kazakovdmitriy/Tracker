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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCardView.reuseIdentifier, 
                                                            for: indexPath) as? TrackerCardView 
        else {
            return UICollectionViewCell()
        }
        
        let item = categories[indexPath.section].trackers[indexPath.row]
        cell.configure(id: item.id, 
                       title: item.name,
                       bgColor: item.color,
                       emoji: item.emoji,
                       plusDelegate: self)

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
        // Установите нужный размер ячейки
        
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

extension TrackerCollectionViewDelegate: TrackerCardViewProtocol {
    func didTapPlusButton(with id: UUID, and state: Bool) {
        
        guard let currentDate = currentDate else { return }
        
        if currentDate > Date() {
            print("Нельзя отмечать будущие трекеры")
        } else {
            print("Нажата кнопка плюс на трекере: \(id) в состоянии \(state) для даты: \(currentDate)")
        }
        
    }
}
