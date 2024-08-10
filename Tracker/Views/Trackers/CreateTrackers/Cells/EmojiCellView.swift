//
//  EmojiCardView.swift
//  Tracker
//
//  Created by Дмитрий on 14.07.2024.
//

import UIKit

final class EmojiCellView: UICollectionViewCell {
    
    static let reuseIdentifier = "EmojiCellView"
    
    private lazy var bgView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .ypLightGray
        
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private lazy var emojiView: UILabel = {
        let label = UILabel()
        
        label.font = Fonts.sfPro(with: 32, .bold)
        label.textAlignment = .center
        
        return label
    }()
    
    func configure(emoji: String) {
        emojiView.text = emoji
        changeChoiseStatus(isHiden: true)
    }
    
    func changeChoiseStatus(isHiden: Bool) {
        bgView.isHidden = isHiden
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.setupView(bgView)
        contentView.setupView(emojiView)
        
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: topAnchor),
            bgView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            emojiView.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            emojiView.centerYAnchor.constraint(equalTo: bgView.centerYAnchor)
        ])
    }
}
