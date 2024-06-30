//
//  PopUpViewController.swift
//  Tracker
//
//  Created by Дмитрий on 28.06.2024.
//

import UIKit

class PopUpViewController: BaseController {
    
    private let titleString: String
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = titleString
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        
        return label
    }()
    
    init(title text: String) {
        self.titleString = text
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PopUpViewController {
    override func setupViews() {
        super.setupViews()
        
        view.setupView(titleLabel)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 25)
        ])
    }
}

