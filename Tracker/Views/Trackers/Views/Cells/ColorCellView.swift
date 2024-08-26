//
//  ColorCellView.swift
//  Tracker
//
//  Created by Дмитрий on 14.07.2024.
//

import UIKit

final class ColorCellView: UICollectionViewCell {
    static let reuseIdentifier = "ColorCellView"
    
    private lazy var colorView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .red
        
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private lazy var borderView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .clear
        
        view.layer.borderColor = UIColor.ypBlack.withAlphaComponent(0.3).cgColor
        view.layer.borderWidth = 3
        
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    func configure(with color: UIColor) {
        colorView.backgroundColor = color
        borderView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
    }
    
    func changeChoiseStatus(isHiden: Bool) {
        borderView.isHidden = isHiden
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.setupView(borderView)
        contentView.setupView(colorView)
        
        borderView.isHidden = true
        
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            borderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            colorView.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 6),
            colorView.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -6),
            colorView.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 6),
            colorView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -6)
        ])
    }
}
