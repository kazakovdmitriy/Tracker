//
//  ChoiseCategoryViewController.swift
//  Tracker
//
//  Created by Дмитрий on 03.07.2024.
//

import UIKit

final class CategoryViewController: PopUpViewController {
    weak var delegate: ScheduleViewControllerDelegate?
    
    var tableCategory: [String] = []
    
    private let tableViewDelegate = CategoryTableViewDelegate()
    
    private lazy var categoryTableView: TrackersTableView<CategoryTableViewCell> = TrackersTableView(
        cellType: CategoryTableViewCell.self,
        cellIdentifier: CategoryTableViewCell.reuseIdentifier,
        isScrollEnable: true
    )
    
    private lazy var doneButton = MainButton(title: "Готово")
    private lazy var stubView = StubView()
    
    init() {
        super.init(title: R.Strings.NavTitle.category)
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
        
        if tableCategory.isEmpty {
            
            categoryTableView.isHidden = true
            stubView.isHidden = false
            
            let emptyImage = UIImage(named: "empty_trackers_image") ?? UIImage()
            stubView.configure(with: "Привычки и события можно объединить по смыслу", and: emptyImage)
            
            doneButton.configure(action: #selector(addCategoryButtonTapped), newTitle: "Добавить категорию")
        } else {
            
            categoryTableView.isHidden = false
            stubView.isHidden = true
            
            categoryTableView.delegate = tableViewDelegate
            tableViewDelegate.data = tableCategory
            categoryTableView.dataSource = tableViewDelegate
            
            doneButton.configure(action: #selector(choiseCategoryButtonTapped))
        }
        
        
    }
    
    @objc private func choiseCategoryButtonTapped() {
                
        dismiss(animated: true)
    }
    
    @objc private func addCategoryButtonTapped() {
                
        dismiss(animated: true)
    }
}
