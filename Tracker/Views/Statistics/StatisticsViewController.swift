//
//  ViewController.swift
//  Tracker
//
//  Created by Дмитрий on 20.06.2024.
//

import UIKit

final class StatisticsViewController: BaseController {
    
    private let trackerRecordStore = TrackerRecordStore.shared
    
    private var statistics: [String: Int] = [:]
    private var statisticNames: [String] = []
    
    private lazy var stubView = StubView(type: .nothingToAnalyze)
    private lazy var tableView = UITableView()
}

extension StatisticsViewController {
    override func setupViews() {
        super.setupViews()
        
        view.setupView(stubView)
        view.setupView(tableView)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            stubView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 24)
        ])
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        setupNavigationBar()
        setupTableView()
        
        statistics["Трекеров завершено"] = trackerRecordStore.countTrackerRecords()
        statisticNames = Array(statistics.keys)
    }
}

private extension StatisticsViewController {
    func setupNavigationBar() {
        // Устанавливаем крупный заголовок
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = Strings.NavBar.statistics
    }
    
    func setupTableView() {
        tableView.register(StatisticsTableCell.self, forCellReuseIdentifier: StatisticsTableCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension StatisticsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        statisticNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StatisticsTableCell.reuseIdentifier, for: indexPath
        ) as? StatisticsTableCell else {
            return UITableViewCell()
        }
        
        let statisticName = statisticNames[indexPath.row]
        let statisticCount = statistics[statisticName] ?? 0
        
        cell.configure(statisticCount: statisticCount, statisticName: statisticName)
        
        return cell
    }
    
    
}

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
}
