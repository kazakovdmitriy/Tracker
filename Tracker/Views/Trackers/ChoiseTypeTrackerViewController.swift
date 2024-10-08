//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Дмитрий on 28.06.2024.
//

import UIKit

protocol CreateTrackerViewControllerDelegate: AnyObject {
    func selectedPracticeVC()
    func selectedIrregularVC()
}

final class ChoiseTypeTrackerViewController: PopUpViewController {
    
    // MARK: - Public Properties
    weak var delegate: CreateTrackerViewControllerDelegate?

    // MARK: - Private Properties
    private lazy var practiceButton = MainButton(title: Strings.CreateTrackerVC.practiceButton)
    private lazy var irregularEventButton = MainButton(title: Strings.CreateTrackerVC.irregularEventButton)
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        return view
    }()
    
    // MARK: - Initializers
    init() {
        super.init(title: Strings.NavTitle.createTrackers)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}

// MARK: - Setup View
extension ChoiseTypeTrackerViewController {
    override func setupViews() {
        super.setupViews()
        
        view.setupView(stackView)
        stackView.addArrangedSubview(practiceButton)
        stackView.addArrangedSubview(irregularEventButton)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        practiceButton.configure(action: #selector(practiceButtonTapped))
        irregularEventButton.configure(action: #selector(irregularButtonTapped))
    }
}

// MARK: - Selectros
private extension ChoiseTypeTrackerViewController {
    @objc func practiceButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.selectedPracticeVC()
        }
    }
    
    @objc func irregularButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.selectedIrregularVC()
        }
    }
}
