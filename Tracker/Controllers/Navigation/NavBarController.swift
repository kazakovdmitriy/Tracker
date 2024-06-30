//
//  NavBarController.swift
//  Tracker
//
//  Created by Дмитрий on 20.06.2024.
//

import UIKit

final class NavBarController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configure() {
        view.backgroundColor = .ypWhite
        navigationBar.isTranslucent = false
    }
}
