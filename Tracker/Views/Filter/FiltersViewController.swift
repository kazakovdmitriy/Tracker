//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Дмитрий on 19.08.2024.
//

import UIKit

protocol FiltersViewDelegateProtocol: AnyObject {
    func allTrackers()
    func todayTrackers()
    func doneTrackers()
    func unfinishedTrackers()
}

final class FiltersViewController: PopUpViewController {
    
    weak var delegate: FiltersViewDelegateProtocol?
    
    private let filtres: [String] = ["Все трекеры",
                                     "Трекеры на сегодня",
                                     "Завершенные",
                                     "Не завершенные"]
    
    private var selectedIndex: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKeys.selectedFilter) 
        }
        
        set(newValue) {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKeys.selectedFilter)
        }
    }
    
    private lazy var tableView: TrackersTableView<CategoryTableViewCell> = TrackersTableView(
        cellType: CategoryTableViewCell.self,
        cellIdentifier: CategoryTableViewCell.reuseIdentifier,
        isScrollEnable: true
    )
    
    // MARK: - Initializers
    init() {
        super.init(title: Strings.NavTitle.filter)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FiltersViewController {
    override func setupViews() {
        super.setupViews()
        
        view.setupView(tableView)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 87),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension FiltersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, 
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        selectedIndex = indexPath.row
        
        switch indexPath.row {
        case 0: delegate?.allTrackers()
        case 1: delegate?.todayTrackers()
        case 2: delegate?.doneTrackers()
        case 3: delegate?.unfinishedTrackers()
        default: break
        }
        
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard let cell = cell as? CategoryTableViewCell else { return }
        
        let totalRows = tableView.numberOfRows(inSection: indexPath.section)
        cell.cornerRadius = 16.0
        
        if totalRows == 1 {
            cell.roundedCorners = [.allCorners]
        } else {
            if indexPath.row == 0 {
                cell.roundedCorners = [.topLeft, .topRight]
            } else if indexPath.row == totalRows - 1 {
                cell.roundedCorners = [.bottomLeft, .bottomRight]
            } else {
                cell.roundedCorners = []
            }
        }
        
        cell.setNeedsLayout()
    }
}

extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryTableViewCell.reuseIdentifier, for: indexPath
        ) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        
        let isSelected = indexPath.row == selectedIndex
        
        cell.configure(with: filtres[indexPath.row],
                       isSelected: isSelected)
    
        return cell
    }
    
    
}
