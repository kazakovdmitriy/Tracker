//
//  ChoiseCategoryViewController.swift
//  Tracker
//
//  Created by Дмитрий on 03.07.2024.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func doneButtonTapped(selectedCategory: String)
}

final class CategoryViewController: PopUpViewController {
    
    // MARK: - Public Properties
    weak var delegate: CategoryViewControllerDelegate?
    
    // MARK: - Private Properties
    private var categories: [String] = []
    private var selectedCategoryIndex: Int?
    private let trackerCategoryStore = TrackerCategoryStore.shared
    
    private lazy var categoryTableView: TrackersTableView<CategoryTableViewCell> = TrackersTableView(
        cellType: CategoryTableViewCell.self,
        cellIdentifier: CategoryTableViewCell.reuseIdentifier,
        isScrollEnable: true
    )
    
    private lazy var doneButton = MainButton(title: "Добавить категорию")
    private lazy var stubView = StubView()
    
    // MARK: - Initializers
    init() {
        super.init(title: Strings.NavTitle.category)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CategoryViewController {
    override func setupViews() {
        super.setupViews()
        
        view.setupView(categoryTableView)
        view.setupView(doneButton)
        view.setupView(stubView)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            
            categoryTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 87),
            categoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryTableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -24),
            
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            stubView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stubView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            stubView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60)
        ])
        
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        doneButton.configure(action: #selector(addCategoryButtonTapped))
        categories = trackerCategoryStore.loadCategoryNames()
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        
        if categories.isEmpty {
            
            showTable(isHidden: false)
            
            let emptyImage = UIImage(named: "empty_trackers_image") ?? UIImage()
            stubView.configure(with: "Привычки и события можно объединить по смыслу", and: emptyImage)
        } else {
            showTable(isHidden: true)
        }
    }
    
    private func showTable(isHidden: Bool) {
        categoryTableView.isHidden = !isHidden
        stubView.isHidden = isHidden
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        selectedCategoryIndex = indexPath.row
        tableView.reloadData()
        
        delegate?.doneButtonTapped(selectedCategory: categories[indexPath.row])
        
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard let cell = cell as? CategoryTableViewCell else { return }
        
        let totalRows = tableView.numberOfRows(inSection: indexPath.section)
        
        if totalRows == 1 {
            cell.cornerRadius = 16.0
            cell.roundedCorners = [.allCorners]
        } else {
            cell.cornerRadius = 16.0
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

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryTableViewCell.reuseIdentifier, for: indexPath
        ) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        
        let isSelected = indexPath.row == selectedCategoryIndex
        
        cell.configure(with: categories[indexPath.row], isSelected: isSelected)
        
        return cell
    }
}

private extension CategoryViewController {
    @objc func addCategoryButtonTapped() {
        let createCategoryVC = CreateNewCategoryViewController()
        createCategoryVC.delegate = self
        present(createCategoryVC, animated: true)
    }
}

extension CategoryViewController: CreateNewCategoryProtocol {
    func didCreateNewCategory(newCategory: String) {
        categories = trackerCategoryStore.loadCategoryNames()
        showTable(isHidden: true)
        categoryTableView.reloadData()
    }
}
