//
//  BaseController.swift
//  Tracker
//
//  Created by Дмитрий on 20.06.2024.
//

import UIKit

class BaseController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        constraintViews()
        configureAppearance()
    }
}

@objc extension BaseController {
    func setupViews() {}
    func constraintViews() {}
    
    func configureAppearance() {
        view.backgroundColor = .ypWhite
    }
}
