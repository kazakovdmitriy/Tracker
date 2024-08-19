//
//  NewPractiseViewController.swift
//  Tracker
//
//  Created by Дмитрий on 28.06.2024.
//

import UIKit

final class NewPracticeViewController: CreateBaseController {
    
    // MARK: - Public Properties
    weak var delegate: CreateBaseControllerDelegate?
    var selectedWeekDays: [WeekDays] = []
    
    // MARK: - Private Properties
    private let tableDelegate = TrackersTableViewDelegate()
    
    // MARK: - Initializers
    init() {
        super.init(title: Strings.NavTitle.newPractice,
                   tableCategory: ["Категория", "Расписание"]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Buttons handlers
extension NewPracticeViewController {
    override func configureAppearance() {
        tableDelegate.view = self
        
        tableViewDelegate = tableDelegate
        
        super.configureAppearance()
        
        addActionToButton(create: #selector(createButtonTapped), 
                          cancle: #selector(cancleButtonTapped))
    }
    
    @objc private func cancleButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        
        if let category = tableDelegate.choiseCategory {
            let schedule = tableDelegate.weekDaysSchedule
            
            guard let trackerData = getData() else { return }
            
            let newTracker = Tracker(id: UUID(),
                                     name: trackerData.name,
                                     color: trackerData.color,
                                     emoji: trackerData.emoji,
                                     type: .practice,
                                     schedule: schedule)
            
            delegate?.didTapCreateTrackerButton(category: category, tracker: newTracker)
        } else {
            print("[NewPracticeViewController]: Не выбрана категория")
        }
        
        dismiss(animated: true)
    }
}

extension NewPracticeViewController: ScheduleViewControllerDelegate {
    func doneButtonTapped(weakDays weekDays: [WeekDays]) {
        tableDelegate.weekDaysSchedule = weekDays
        reloadTable()
    }
}

extension NewPracticeViewController: CategoryViewControllerDelegate {
    func doneButtonTapped(selectedCategory: String) {
        tableDelegate.choiseCategory = selectedCategory
        reloadTable()
    }
}
