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
    
    // MARK: - Private Properties
    private let type: CreateBaseType
    private let tableDelegate = TrackersTableViewDelegate()
    
    // MARK: - Initializers
    init(trackerType: TrackerType) {
        
        self.type = .create
        
        super.init(title: Strings.NavTitle.newIrregular,
                   trackerType: trackerType,
                   createType: self.type
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewIrregularViewController {
    override func configureAppearance() {
        tableDelegate.view = self
        
        tableViewDelegate = tableDelegate
        
        super.configureAppearance()
        
        addActionToButton(create: #selector(createButtonTapped),
                          cancle: #selector(cancleButtonTapped))
        
        reloadTable()
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
                                     originalCategory: category,
                                     completedDate: [],
                                     type: .irregular,
                                     schedule: [WeekDays.monday,
                                                WeekDays.tuesday,
                                                WeekDays.wednesday,
                                                WeekDays.thursday,
                                                WeekDays.friday,
                                                WeekDays.saturday,
                                                WeekDays.sunday])
            
            delegate?.didTapCreateTrackerButton(category: category, tracker: newTracker, type: type)
        } else {
            print("[NewIrregularViewController]: Не выбрана категория")
        }
        
        dismiss(animated: true)
    }
}

extension NewIrregularViewController: CategoryViewControllerDelegate {
    func doneButtonTapped(selectedCategory: String) {
        tableDelegate.choiseCategory = selectedCategory
        reloadTable()
    }
}
