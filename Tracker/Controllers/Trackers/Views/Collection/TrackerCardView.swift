//
//  TrackerCardView.swift
//  Tracker
//
//  Created by Дмитрий on 24.06.2024.
//

import UIKit

// func configure(id: UUID, title: String, bgColor: UIColor, emoji: String, isDoneTracker: Bool, plusDelegate: TrackerCardViewProtocol)

struct TrackerCardConfig {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let days: Int
    let isDone: Bool
    let plusDelegate: TrackerCardViewProtocol
}

protocol TrackerCardViewProtocol: AnyObject {
    func didTapPlusButton(with id: UUID, isActive: Bool)
}

final class TrackerCardView: UICollectionViewCell {
    
    weak var delegate: TrackerCardViewProtocol?
    
    static let reuseIdentifier = "TrackerCardView"
    
    private var id: UUID?
    private lazy var cardView = CardView()
    private lazy var quantityView = QuantityManagementView()
    
    func configure(config: TrackerCardConfig) {
        self.id = config.id
        delegate = config.plusDelegate
        cardView.configure(title: config.title, bgColor: config.color, emoji: config.emoji)
        quantityView.configure(buttonBg: config.color, days: config.days, delegate: self, isDone: config.isDone)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)
        
        quantityView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(quantityView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),
            
            quantityView.topAnchor.constraint(equalTo: cardView.bottomAnchor),
            quantityView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            quantityView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            quantityView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrackerCardView: QuantityManagementViewProtocol {
    func didTapPlusCardButton(with state: Bool) {
        guard let id = id else { return }
        delegate?.didTapPlusButton(with: id, isActive: state)
    }
}
