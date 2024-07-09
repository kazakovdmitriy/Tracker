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
    var categories: [String] = []
    
    // MARK: - Private Properties
    private let tableDelegate = TrackersTableViewDelegate()
    
    // MARK: - Initializers
    init() {
        super.init(title: R.Strings.NavTitle.newPractice,
                   tableCategory: ["Категория", "Расписание"],
                   trackerCategory: categories
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewPracticeViewController {
    override func configureAppearance() {
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
            let schedule = tableDelegate.weekDaysSchedule
            
            let newTracker = Tracker(id: UUID(),
                                     name: "Тест",
                                     color: .ypColorSelection13,
                                     emoji: "☠️",
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
        trackersTableView.reloadData()
    }
}

extension NewPracticeViewController: CategoryViewControllerDelegate {
    func doneButtonTapped(selectedCategory: String) {
        tableDelegate.choiseCategory = selectedCategory
        trackersTableView.reloadData()
    }
}
