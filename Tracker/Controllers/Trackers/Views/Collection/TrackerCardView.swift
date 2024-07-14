//
//  TrackerCardView.swift
//  Tracker
//
//  Created by Дмитрий on 24.06.2024.
//

import UIKit

protocol TrackerCardViewProtocol: AnyObject {
    func didTapPlusButton(with id: UUID, isActive: Bool)
}

final class TrackerCardView: UICollectionViewCell {
    
    static let reuseIdentifier = "TrackerCardView"
    
    weak var delegate: TrackerCardViewProtocol?
    
    private var id: UUID?
    private lazy var cardView = CardView()
    private lazy var quantityView = QuantityManagementView()
    
    func configure(config: TrackerCardConfig) {
        self.id = config.id
        delegate = config.plusDelegate
        cardView.configure(title: config.title, bgColor: config.color, emoji: config.emoji)
        quantityView.configure(buttonBg: config.color, days: config.days, delegate: self, isDone: config.isDone, date: config.date)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.setupView(cardView)
        contentView.setupView(quantityView)
        
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
