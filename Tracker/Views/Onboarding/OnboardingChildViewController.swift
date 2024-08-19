//
//  OnboardingChildViewController.swift
//  Tracker
//
//  Created by Дмитрий on 12.08.2024.
//

import UIKit

final class OnboardingChildViewController: BaseController {
    private let bgImage: UIImage
    private let labelString: String
    
    init(page: OnboardingPageModel) {
        
        self.bgImage = page.image
        self.labelString = page.text
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var backgroundImage: UIImageView = {
        let imageVC = UIImageView()
        let image = bgImage
        
        imageVC.image = image
        imageVC.contentMode = .scaleAspectFill
        
        return imageVC
    }()
    
    private lazy var labelText: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 32)
        label.textColor = .ypNavButtonTitle
        label.textAlignment = .center
        label.numberOfLines = 0
        
        label.text = labelString
        
        return label
    }()
}

extension OnboardingChildViewController {
    override func setupViews() {
        super.setupViews()
        
        view.setupView(backgroundImage)
        view.setupView(labelText)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            labelText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            labelText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            labelText.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 70),
            labelText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
