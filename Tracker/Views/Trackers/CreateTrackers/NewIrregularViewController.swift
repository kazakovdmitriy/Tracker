//
//  NewIrregularViewController.swift
//  Tracker
//
//  Created by Дмитрий on 30.06.2024.
//

import UIKit

final class NewIrregularViewController: CreateBaseController {
    
    // MARK: - Public Properties
    weak var delegate: CreateBaseControllerDelegate?
    var categories: [String] = []
    
    // MARK: - Private Properties
    private let tableDelegate = TrackersTableViewDelegate()
    
    // MARK: - Initializers
    init() {
        super.init(title: Strings.NavTitle.newIrregular,
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
        
        addActionToButton(create: #selector(createButtonTapped), cancle: #selector(cancleButtonTapped))
    }
    
    @objc private func cancleButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        if let category = tableDelegate.choiseCategory {
            
            guard let trackerData = getData() else { return }
            
            let newTracker = Tracker(id: UUID(),
                                     name: trackerData.name,
                                     color: trackerData.color,
                                     emoji: trackerData.emoji,
                                     schedule: [WeekDays.none])
            
            delegate?.didTapCreateTrackerButton(category: category, tracker: newTracker)
        } else {
            print("[NewPracticeViewController]: Не выбрана категория")
        }
        
        dismiss(animated: true)
    }
}

