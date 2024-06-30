//
//  CreateBaseController.swift
//  Tracker
//
//  Created by Дмитрий on 30.06.2024.
//

import UIKit

class CreateBaseController: PopUpViewController {
    
    var tableCategory: [String]
    
    private lazy var nameTrackerInputField: UITextField = {
        let textField = UITextField()
        
        textField.backgroundColor = .ypBackground
        textField.font = UIFont.systemFont(ofSize: 17)
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "Введите название трекера",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.ypGray]
        )
        textField.textColor = .ypBlack
        
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        
        textField.clearButtonMode = .whileEditing
        
        textField.delegate = self
        
        return textField
    }()
    
    private let tableViewDelegate = TrackersTableViewDelegate()
    private let tableViewDataSource = TrackersTableViewDataSource()
    private let cell = TrackersTableViewCell()
    private lazy var trackersTableView: TrackersTableView<TrackersTableViewCell> = TrackersTableView(
        cellType: TrackersTableViewCell.self,
        cellIdentifier: TrackersTableViewCell.reuseIdentifier
    )
    
    private lazy var cancleButton = MainButton(title: "Отменить")
    private lazy var createButton = MainButton(title: "Создать")
    
    private lazy var stackButtonView: UIStackView = {
        let stack = UIStackView()
        
        stack.spacing = 8
        stack.distribution = .fillEqually
        
        return stack
    }()
    
    init(tableCategory: [String], 
         title: String) {
        
        self.tableCategory = tableCategory
        
        super.init(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CreateBaseController {
    override func setupViews() {
        super.setupViews()
        
        view.setupView(nameTrackerInputField)
        
        view.setupView(stackButtonView)
        stackButtonView.addArrangedSubview(cancleButton)
        stackButtonView.addArrangedSubview(createButton)
        
        view.setupView(trackersTableView)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            nameTrackerInputField.heightAnchor.constraint(equalToConstant: 75),
            nameTrackerInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTrackerInputField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTrackerInputField.topAnchor.constraint(equalTo: view.topAnchor, constant: 87),
            
            trackersTableView.topAnchor.constraint(equalTo: nameTrackerInputField.bottomAnchor, constant: 22),
            trackersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackersTableView.heightAnchor.constraint(equalToConstant: 150),
            
            stackButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        createButton.deactivateButton()
        
        cancleButton.setColors(bg: .clear, title: .ypRed)
        cancleButton.layer.cornerRadius = 16
        cancleButton.layer.borderColor = UIColor.ypRed.cgColor
        cancleButton.layer.borderWidth = 1
        
        createButton.configure(action: #selector(createButtonTapped), target: nil)
        cancleButton.configure(action: #selector(cancleButtonTapped), target: nil)
        
        tableViewDelegate.view = self
        trackersTableView.delegate = tableViewDelegate
        tableViewDataSource.data = tableCategory
        trackersTableView.dataSource = tableViewDataSource
    }
    
    @objc private func cancleButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        print("нажали создать")
    }
}

extension CreateBaseController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        createButton.deactivateButton()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let userEnteredString = textField.text
        let newString = (userEnteredString! as NSString).replacingCharacters(in: range, with: string) as NSString
        if  newString != ""{
            createButton.activateButton()
        } else {
            createButton.deactivateButton()
        }
        return true
    }
    
}

