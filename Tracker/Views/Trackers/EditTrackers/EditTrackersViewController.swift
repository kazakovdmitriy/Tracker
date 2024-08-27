//
//  EditTrackersViewController.swift
//  Tracker
//
//  Created by Дмитрий on 26.08.2024.
//

import UIKit

final class EditTrackersViewController: CreateBaseController {
    // MARK: - Public Properties
    weak var delegate: CreateBaseControllerDelegate?
    var selectedWeekDays: [WeekDays] = []
    var tracker: Tracker
    
    // MARK: - Private Properties
    private let type: CreateBaseType
    private let tableDelegate = TrackersTableViewDelegate()
    
    // MARK: - Initializers
    init(tracker: Tracker) {
        
        self.tracker = tracker
        self.type = .edit
        super.init(title: Strings.NavTitle.editTrackers,
                   trackerType: tracker.type,
                   createType: self.type
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EditTrackersViewController {
    override func configureAppearance() {
        tableDelegate.view = self
        tableViewDelegate = tableDelegate
        
        super.configureAppearance()
        
        tableDelegate.choiseCategory = tracker.originalCategory
        tableDelegate.weekDaysSchedule = tracker.schedule
        
        addActionToButton(create: #selector(editButtonTapped),
                          cancle: #selector(cancleButtonTapped))
        
        reloadTable()
        
        configure(tracker: tracker)
    }
    
    @objc private func cancleButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func editButtonTapped() {
        
        if let category = tableDelegate.choiseCategory {
            let schedule = tableDelegate.weekDaysSchedule
            
            guard let trackerData = getData() else { return }
            
            let newTracker = Tracker(id: tracker.id,
                                     name: trackerData.name,
                                     color: trackerData.color,
                                     emoji: trackerData.emoji,
                                     originalCategory: category,
                                     completedDate: tracker.completedDate,
                                     type: tracker.type,
                                     schedule: schedule)
            
            delegate?.didTapCreateTrackerButton(category: category, tracker: newTracker, type: type)
        } else {
            print("[EditTrackersViewController]: Не выбрана категория")
        }
        
        dismiss(animated: true)
    }
}

extension EditTrackersViewController: ScheduleViewControllerDelegate {
    func doneButtonTapped(weakDays weekDays: [WeekDays]) {
        tableDelegate.weekDaysSchedule = weekDays
        reloadTable()
    }
}

extension EditTrackersViewController: CategoryViewControllerDelegate {
    func doneButtonTapped(selectedCategory: String) {
        tableDelegate.choiseCategory = selectedCategory
        reloadTable()
    }
}
