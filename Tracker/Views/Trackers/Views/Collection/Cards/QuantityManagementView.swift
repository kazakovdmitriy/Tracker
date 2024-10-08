//
//  QuantityManagementView.swift
//  Tracker
//
//  Created by Дмитрий on 24.06.2024.
//

import UIKit

protocol QuantityManagementViewProtocol: AnyObject {
    func didTapPlusCardButton(with state: Bool)
}

final class QuantityManagementView: BaseView {
    
    weak var delegate: QuantityManagementViewProtocol?
    
    private var isDone: Bool = false
    private var days: Int = 0
    
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
        let image = UIImage(systemName: "plus", 
                            withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate)
        
        button.setImage(image, for: .normal)
        button.tintColor = .ypWhite
        
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    func configure(buttonBg: UIColor, 
                   days: Int,
                   delegate: QuantityManagementViewProtocol,
                   isDone: Bool,
                   date: Date) {
        self.isDone = isDone
        self.delegate = delegate
        self.days = days
        
        addButton.backgroundColor = buttonBg
        dateLabel.text = getDayString(for: days)
        changeButtonStatus()
        
        if date > Date() {
            addButton.isEnabled = false
        } else {
            addButton.isEnabled = true
        }
    }
    
    private func getDayString(for number: Int) -> String {
        let remainder10 = number % 10
        let remainder100 = number % 100
        
        if remainder100 >= 11 && remainder100 <= 14 {
            return "\(number) \(Strings.TrackersCardView.days)"
        } else {
            switch remainder10 {
            case 1:
                return "\(number) \(Strings.TrackersCardView.day)"
            case 2, 3, 4:
                return "\(number) \(Strings.TrackersCardView.twoDays)"
            default:
                return "\(number) \(Strings.TrackersCardView.days)"
            }
        }
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
}

extension QuantityManagementView {
    func makeButtonDone() {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold, scale: .medium)
        let image = UIImage(systemName: "checkmark", 
                            withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate)
        
        addButton.setImage(image, for: .normal)
        
        if let currentColor = addButton.backgroundColor {
            let newColor = currentColor.withAlphaComponent(0.3)
            addButton.backgroundColor = newColor
        }
    }
    
    func makeButtonAdd() {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold, scale: .medium)
        let image = UIImage(systemName: "plus", 
                            withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate)
        
        addButton.setImage(image, for: .normal)
        
        if let currentColor = addButton.backgroundColor {
            let newColor = currentColor.withAlphaComponent(1.0)
            addButton.backgroundColor = newColor
        }
    }
    
    private func changeButtonStatus() {
                
        if isDone {
            makeButtonDone()
        } else {
            makeButtonAdd()
        }
    }
    
    @objc private func addButtonTapped() {
        
        if isDone {
            days -= 1
        } else {
            days += 1
        }
        isDone = !isDone
        
        changeButtonStatus()
        dateLabel.text = getDayString(for: days)
        
        delegate?.didTapPlusCardButton(with: isDone)
    }
}
