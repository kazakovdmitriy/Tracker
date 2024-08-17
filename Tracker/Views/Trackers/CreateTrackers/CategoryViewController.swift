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
    private var viewModel: CategoryViewModel
    
    private lazy var categoryTableView: TrackersTableView<CategoryTableViewCell> = TrackersTableView(
        cellType: CategoryTableViewCell.self,
        cellIdentifier: CategoryTableViewCell.reuseIdentifier,
        isScrollEnable: true
    )
    
    private lazy var doneButton = MainButton(title: "Добавить категорию")
    private lazy var stubView = StubView()
    
    // MARK: - Initializers
    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
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
        
        setupBindings()
        
        doneButton.configure(action: #selector(addCategoryButtonTapped))
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        
        viewModel.loadCategories()
    }
    
    private func setupBindings() {
        viewModel.onCategoriesUpdated = { [weak self] in
            self?.categoryTableView.reloadData()
        }
        
        viewModel.onCategorySelected = { [weak self] selectedCategory in
            self?.delegate?.doneButtonTapped(selectedCategory: selectedCategory)
            self?.dismiss(animated: true)
        }
        
        viewModel.onShowStubView = { [weak self] isEmpty in
            self?.showTable(isHidden: !isEmpty)
            if isEmpty {
                let emptyImage = UIImage(named: "empty_trackers_image") ?? UIImage()
                self?.stubView.configure(with: "Привычки и события можно объединить по смыслу", and: emptyImage)
            }
        }
    }
    
    private func showTable(isHidden: Bool) {
        categoryTableView.isHidden = !isHidden
        stubView.isHidden = isHidden
    }
    
    @objc private func addCategoryButtonTapped() {
        let createCategoryVC = CreateNewCategoryViewController()
        createCategoryVC.delegate = self
        present(createCategoryVC, animated: true)
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
        viewModel.selectCategory(at: indexPath.row)
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

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryTableViewCell.reuseIdentifier, for: indexPath
        ) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        
        let isSelected = indexPath.row == viewModel.selectedCategoryIndex
        cell.configure(with: viewModel.categories[indexPath.row], isSelected: isSelected)
        
        return cell
    }
}

extension CategoryViewController: CreateNewCategoryProtocol {
    func didCreateNewCategory(newCategory: String) {
        viewModel.addCategory(newCategory)
    }
}
