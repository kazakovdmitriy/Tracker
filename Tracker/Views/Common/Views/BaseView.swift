//
//  BaseView.swift
//  Tracker
//
//  Created by Дмитрий on 20.06.2024.
//

import UIKit

class BaseView: UIView {
    init() {
        super.init(frame: .zero)
        
        setupViews()
        constraintViews()
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objc extension BaseView {
    func setupViews() {}
    func constraintViews() {}
    func configureAppearance() {}
}
