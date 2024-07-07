//
//  TrackerCardView.swift
//  Tracker
//
//  Created by Дмитрий on 24.06.2024.
//

import UIKit

protocol TrackerCardViewProtocol: AnyObject {
    func didTapPlusButton(with id: UUID, and state: Bool)
}

final class TrackerCardView: UICollectionViewCell {
    
    weak var delegate: TrackerCardViewProtocol?
    
    static let reuseIdentifier = "TrackerCardView"
    
    private var id: UUID?
    private lazy var cardView = CardView()
    private lazy var quantityView = QuantityManagementView()
    
    func configure(id: UUID, title: String, bgColor: UIColor, emoji: String, plusDelegate: TrackerCardViewProtocol) {
        self.id = id
        delegate = plusDelegate
        cardView.configure(title: title, bgColor: bgColor, emoji: emoji)
        quantityView.configure(buttonBg: bgColor, days: 0, delegate: self)
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
        delegate?.didTapPlusButton(with: id, and: state)
    }
}
