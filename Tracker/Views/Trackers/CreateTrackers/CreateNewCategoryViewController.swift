//
//  CreateNewCategoryViewController.swift
//  Tracker
//
//  Created by Дмитрий on 14.08.2024.
//

import UIKit

protocol CreateNewCategoryProtocol: AnyObject {
    func didCreateNewCategory(newCategory: String)
}

final class CreateNewCategoryViewController: PopUpViewController {
    
    weak var delegate: CreateNewCategoryProtocol?
    
    private let trackerCategoryStore = TrackerCategoryStore.shared
    
    private lazy var doneButton = MainButton(title: "Готово")
    
    private lazy var nameCategoryInputField: UITextField = {
        let textField = UITextField()
        
        textField.backgroundColor = .ypBackground
        textField.font = UIFont.systemFont(ofSize: 17)
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "Введите название категории",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.ypGray]
        )
        textField.textColor = .ypBlack
        
        textField.borderStyle = .none
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.rightView = paddingView
        textField.rightViewMode = .always
        
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        
        textField.clearButtonMode = .whileEditing
        
        textField.delegate = self
        
        return textField
    }()
    
    // MARK: - Initializers
    init() {
        super.init(title: Strings.NavTitle.createCategory)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CreateNewCategoryViewController {
    override func setupViews() {
        super.setupViews()
        
        view.setupView(nameCategoryInputField)
        view.setupView(doneButton)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            nameCategoryInputField.heightAnchor.constraint(equalToConstant: 75),
            nameCategoryInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameCategoryInputField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameCategoryInputField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 63),
            
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        doneButton.deactivateButton()
        doneButton.configure(action: #selector(didTapDoneButton))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        nameCategoryInputField.resignFirstResponder()
    }
    
    @objc private func didTapDoneButton() {
        guard let newCategoryInput = nameCategoryInputField.text else { return }
        let newTrackerCategory = TrackerCategory(name: newCategoryInput,
                                                 trackers: [])
        trackerCategoryStore.createTrackerRecord(trackerCategory: newTrackerCategory)
        delegate?.didCreateNewCategory(newCategory: newCategoryInput)
        
        dismiss(animated: true)
    }
}

extension CreateNewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneButton.deactivateButton()
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let userEnteredString = textField.text
        let newString = (userEnteredString! as NSString).replacingCharacters(in: range, with: string) as NSString
        if  newString != "" {
            doneButton.activateButton()
        } else {
            doneButton.deactivateButton()
        }
        return true
    }
}
