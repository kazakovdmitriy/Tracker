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
        view.alignment = .center
        view.spacing = 15
        return view
    }()
    
    private lazy var stubEmptyLabel: UILabel = {
        let label = UILabel()
        
        label.font = R.Fonts.sfPro(with: 12)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private lazy var stubEmptyImage: UIImageView = {
        let view = UIImageView()
        
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
        stackView.addArrangedSubview(stubEmptyImage)
        stackView.addArrangedSubview(stubEmptyLabel)
        
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            stubEmptyImage.widthAnchor.constraint(equalToConstant: 80),
            stubEmptyImage.heightAnchor.constraint(equalTo: stubEmptyImage.widthAnchor)
        ])
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
    }
}
