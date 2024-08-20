//
//  StubView.swift
//  Tracker
//
//  Created by Дмитрий on 28.06.2024.
//

import UIKit

final class StubView: BaseView {
    
    private var imageName: String
    private var text: String
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 15
        return view
    }()
    
    private lazy var stubEmptyLabel: UILabel = {
        let label = UILabel()
        
        label.text = text
        label.font = Fonts.sfPro(with: 12)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private lazy var stubEmptyImage: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: imageName) ?? UIImage()
        
        view.image = image
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    init(imageName: String, text: String) {
        self.imageName = imageName
        self.text = text
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
}
