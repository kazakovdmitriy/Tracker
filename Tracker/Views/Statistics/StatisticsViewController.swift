//
//  ViewController.swift
//  Tracker
//
//  Created by Дмитрий on 20.06.2024.
//

import UIKit

final class StatisticsViewController: BaseController {
    
    private var viewModel: StatisticsViewModelProtocol
    
    private lazy var stubView = StubView(type: .nothingToAnalyze)
    private lazy var tableView = UITableView()
    
    init(viewModel: StatisticsViewModelProtocol = StatisticsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.fetchTrackers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
        
        setupBindings()
        setupNavigationBar()
        setupTableView()
        
        showStub(isHide: viewModel.trackersCount == 0)
    }
}

private extension StatisticsViewController {
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = Strings.NavBar.statistics
    }
    
    func setupTableView() {
        tableView.register(StatisticsTableCell.self, 
                           forCellReuseIdentifier: StatisticsTableCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
    }
    
    func showStub(isHide: Bool) {
        tableView.isHidden = isHide
        stubView.isHidden = !isHide
    }
    
    func setupBindings() {
        viewModel.onStatisticsUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.onTrackerUpdate = { [weak self] isEmpty in
            self?.showStub(isHide: isEmpty)
        }
    }
}

extension StatisticsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.statistics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StatisticsTableCell.reuseIdentifier, for: indexPath
        ) as? StatisticsTableCell else {
            return UITableViewCell()
        }
        
        let statisticsName = Array(viewModel.statistics.keys)
        let statisticValue = viewModel.statistics[statisticsName[indexPath.row]] ?? 0
        
        
        cell.configure(statisticCount: statisticValue, statisticName: statisticsName[indexPath.row])
        
        return cell
    }
}

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
}
