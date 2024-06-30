//
//  QuantityManagementView.swift
//  Tracker
//
//  Created by Дмитрий on 24.06.2024.
//

import UIKit

final class QuantityManagementView: BaseView {
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        
        let buttonSize: CGFloat = 34
        button.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        button.layer.cornerRadius = buttonSize / 2
        button.layer.masksToBounds = true
        
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold, scale: .medium)
        let image = UIImage(systemName: "plus", withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate)
        
        button.setImage(image, for: .normal)
        button.tintColor = .ypWhite
        
        return button
    }()
    
    func configure(buttonBg: UIColor, days: Int) {
        addButton.backgroundColor = buttonBg
        dateLabel.text = "\(days) дней"
    }
}

extension QuantityManagementView {
    override func setupViews() {
        super.setupViews()
        
        setupView(addButton)
        setupView(dateLabel)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            addButton.widthAnchor.constraint(equalToConstant: 34),
            addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            dateLabel.centerYAnchor.constraint(equalTo: addButton.centerYAnchor)
        ])
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        dateLabel.text = "1 день"
        addButton.backgroundColor = .ypColorSelection1
    }
}
