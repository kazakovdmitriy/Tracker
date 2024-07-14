//
//  MainButton.swift
//  Tracker
//
//  Created by Дмитрий on 28.06.2024.
//

import UIKit

final class MainButton: BaseView {
    
    private let title: String
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        
        button.setTitle(title, for: .normal)
        
        button.backgroundColor = .ypBlack
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        
        return button
    }()
    
    init(title: String) {
        self.title = title
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(action: Selector, newTitle: String? = nil) {
        
        if let newTitle {
            button.setTitle(newTitle, for: .normal)
        }
        
        button.addTarget(nil, action: action, for: .touchUpInside)
    }
    
    func deactivateButton() {
        button.backgroundColor = .ypGray
        button.isUserInteractionEnabled = false
    }
    
    func activateButton() {
        button.backgroundColor = .ypBlack
        button.isUserInteractionEnabled = true
    }
    
    func setColors(bgColor: UIColor, title: UIColor) {
        button.backgroundColor = bgColor
        button.setTitleColor(title, for: .normal)
    }
}

extension MainButton {
    override func setupViews() {
        super.setupViews()
        
        setupView(button)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
