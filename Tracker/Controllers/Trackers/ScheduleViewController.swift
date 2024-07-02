//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Дмитрий on 30.06.2024.
//

import UIKit

final class ScheduleViewController: PopUpViewController {
    
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
        
        doneButton.configure(action: #selector(doneButtonTapped), target: nil)
    }
    
    @objc private func doneButtonTapped() {
        dismiss(animated: true)
    }
}
