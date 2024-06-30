//
//  StubView.swift
//  Tracker
//
//  Created by Дмитрий on 28.06.2024.
//

import UIKit

final class StubView: BaseView {
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    private lazy var stubEmptyLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Что будем отслеживать?"
        label.font = R.Fonts.sfPro(with: 12)
        label.textColor = .ypBlack
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var stubEmptyImage: UIImageView = {
        let image = UIImage(named: "empty_trackers_image")
        let view = UIImageView(image: image)
        
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    func configure(with title: String, and image: UIImage) {
        stubEmptyLabel.text = title
        stubEmptyImage.image = image
    }
}

extension StubView {
    override func setupViews() {
        super.setupViews()
        
        setupView(stackView)
        stackView.setupView(stubEmptyImage)
        stackView.setupView(stubEmptyLabel)
        
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            stubEmptyImage.widthAnchor.constraint(equalToConstant: 80),
            stubEmptyImage.heightAnchor.constraint(equalTo: stubEmptyImage.widthAnchor),
            stubEmptyImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            stubEmptyLabel.topAnchor.constraint(equalTo: stubEmptyImage.bottomAnchor, constant: 15),
            stubEmptyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stubEmptyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
    }
}
