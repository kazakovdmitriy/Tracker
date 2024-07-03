//
//  NewPractiseViewController.swift
//  Tracker
//
//  Created by Дмитрий on 28.06.2024.
//

import UIKit

final class NewPracticeViewController: CreateBaseController {
    
    var selectedWeekDays: [WeekDays] = []
    var categories: [String] = []

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
        let tableDelegate = TrackersTableViewDelegate()
        tableDelegate.view = self
        
        tableViewDelegate = tableDelegate
        tableViewDelegate?.trackersCategory = categories
        
        super.configureAppearance()
    }
}

extension NewPracticeViewController: ScheduleViewControllerDelegate {
    func doneButtonTapped(weakDays weekDays: [WeekDays]) {
        self.selectedWeekDays = weekDays
        print(selectedWeekDays)
    }
}
