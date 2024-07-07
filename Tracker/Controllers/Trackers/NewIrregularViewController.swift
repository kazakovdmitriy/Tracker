//
//  NewIrregularViewController.swift
//  Tracker
//
//  Created by Дмитрий on 30.06.2024.
//

import UIKit

final class NewIrregularViewController: CreateBaseController {
    
    // MARK: - Public Properties
    var categories: [String] = []
    
    // MARK: - Private Properties
    private var tableDelegate: TrackersTableViewDelegate?
    
    // MARK: - Initializers
    init() {
        super.init(title: R.Strings.NavTitle.newIrregular,
                   tableCategory: ["Категория"],
                   trackerCategory: categories
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewIrregularViewController {
    override func configureAppearance() {
        let tableDelegate = TrackersTableViewDelegate()
        tableDelegate.view = self
        
        tableViewDelegate = tableDelegate
        tableViewDelegate?.trackersCategory = categories
        
        super.configureAppearance()
    }
}
