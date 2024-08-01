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
    
    // MARK: - Public Properties
    weak var delegate: ScheduleViewControllerDelegate?
    var tableCategory: [String] = ["Понедельник", "Вторник", "Среда",
                                   "Четверг", "Пятница", "Суббота",
                                   "Воскресенье"]
    
    // MARK: - Private Properties
    private var activatedSwitches: [WeekDays]
    
    private let tableViewDelegate: ScheduleTableViewDelegate
    
    private lazy var scheduleTableView: TrackersTableView<ScheduleTableViewCell> = TrackersTableView (
        cellType: ScheduleTableViewCell.self,
        cellIdentifier: ScheduleTableViewCell.reuseIdentifier,
        isScrollEnable: true
    )
    
    private lazy var doneButton = MainButton(title: "Готово")
    
    // MARK: - Initializers
    init(activatedSwitches: [WeekDays],
         tableViewDelegate: ScheduleTableViewDelegate = ScheduleTableViewDelegate()) {
        self.tableViewDelegate = tableViewDelegate
        self.activatedSwitches = activatedSwitches
        super.init(title: Strings.NavTitle.schedule)
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
        tableViewDelegate.activatedSwitches = activatedSwitches
        scheduleTableView.dataSource = tableViewDelegate
        
        doneButton.configure(action: #selector(doneButtonTapped))
    }
    
    private func getWeekdays(cellIndex: Int) -> WeekDays {
        switch cellIndex {
        case 0: return .monday
        case 1: return .tuesday
        case 2: return .wednesday
        case 3: return .thursday
        case 4: return .friday
        case 5: return .saturday
        case 6: return .sunday
        default: return .none
        }
    }
}

private extension ScheduleViewController {
    @objc func doneButtonTapped() {
        
        var activatedSwitches: [WeekDays] = []
        
        // Перебираем все ячейки таблицы
        for indexPath in scheduleTableView.indexPathsForVisibleRows ?? [] {
            if let cell = scheduleTableView.cellForRow(at: indexPath) as? ScheduleTableViewCell {
                // Проверяем активирован ли переключатель в ячейке
                if cell.isActive {
                    activatedSwitches.append(getWeekdays(cellIndex: cell.switchView.tag))
                }
            }
        }
        delegate?.doneButtonTapped(weakDays: activatedSwitches)
        dismiss(animated: true)
    }
}
