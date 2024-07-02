//
//  CollectionViewDelegate.swift
//  Tracker
//
//  Created by Дмитрий on 02.07.2024.
//

import UIKit

final class TrackerCollectionViewDelegate: NSObject {
    var categories: [TrackerCategory] = []
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCardView.reuseIdentifier, for: indexPath) as! TrackerCardView
        let item = categories[indexPath.section].trackers[indexPath.row]
        cell.configure(title: item.name, bgColor: item.color, emoji: item.emoji)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Unexpected element kind")
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: TrackerSectionHeader.reuseIdentifier,
                                                                     for: indexPath) as! TrackerSectionHeader
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
        return CGSize(width: 167, height: 148)
    }
}
