//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Дмитрий on 30.06.2024.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func doneButtonTapped(weakDays: [WeekDays])
}

final class ScheduleViewController: PopUpViewController {
    
    weak var delegate: ScheduleViewControllerDelegate?
    
    var tableCategory: [String] = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    
    private let tableViewDelegate = ScheduleTableViewDelegate()
    private let cell = ScheduleTableViewCell()
    private lazy var scheduleTableView: TrackersTableView<ScheduleTableViewCell> = TrackersTableView(
        cellType: ScheduleTableViewCell.self,
        cellIdentifier: ScheduleTableViewCell.reuseIdentifier,
        isScrollEnable: true
    )
    
    private lazy var doneButton = MainButton(title: "Готово")
    
    init() {
        super.init(title: R.Strings.NavTitle.schedule)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ScheduleViewController {
    override func setupViews() {
        super.setupViews()
        
        view.setupView(scheduleTableView)
        view.setupView(doneButton)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            
            scheduleTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 87),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleTableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -24),
            
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        scheduleTableView.delegate = tableViewDelegate
        tableViewDelegate.data = tableCategory
        scheduleTableView.dataSource = tableViewDelegate
        
        doneButton.configure(action: #selector(doneButtonTapped))
    }
    
    @objc private func doneButtonTapped() {
        
        var activatedSwitches: [WeekDays] = []
        
        // Перебираем все ячейки таблицы
        for indexPath in scheduleTableView.indexPathsForVisibleRows ?? [] {
            if let cell = scheduleTableView.cellForRow(at: indexPath) as? ScheduleTableViewCell {
                // Проверяем активирован ли переключатель в ячейке
                if cell.isActive {
                    switch cell.switchView.tag {
                    case 0: activatedSwitches.append(.Monday)
                    case 1: activatedSwitches.append(.Tuesday)
                    case 2: activatedSwitches.append(.Wednesday)
                    case 3: activatedSwitches.append(.Thursday)
                    case 4: activatedSwitches.append(.Friday)
                    case 5: activatedSwitches.append(.Saturday)
                    case 6: activatedSwitches.append(.Sunday)
                    default: activatedSwitches.append(.None)
                    }
                    
                }
            }
        }
        
        // Теперь у вас в массиве activatedSwitches будут теги активированных switchView
        delegate?.doneButtonTapped(weakDays: activatedSwitches)
        
        dismiss(animated: true)
    }
}
