//
//  TrackerSectionHeader.swift
//  Tracker
//
//  Created by Дмитрий on 30.06.2024.
//

import UIKit

final class TrackerSectionHeader: UICollectionReusableView {
    static let reuseIdentifier = "TrackerSectionHeader"
    
    private lazy var label: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        
        return label
    }()
    
    func setText(_ text: String) {
        label.text = text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TrackerSectionHeader {
    func configure() {
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}
