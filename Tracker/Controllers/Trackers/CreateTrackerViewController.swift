//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Дмитрий on 28.06.2024.
//

import UIKit

final class CreateTrackerViewController: PopUpViewController {
    
    var categories: [String] = []
    
    private lazy var practiceButton = MainButton(title: "Привычка")
    private lazy var irregularEventButton = MainButton(title: "Нерегулярные событие")
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        return view
    }()
    
    init() {
        super.init(title: R.Strings.NavTitle.createTrackers)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CreateTrackerViewController {
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
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        practiceButton.configure(action: #selector(practiceButtonTapped))
        irregularEventButton.configure(action: #selector(irregularButtonTapped))
    }
    
    @objc private func practiceButtonTapped() {
        let newPracticeVC = NewPracticeViewController()
        newPracticeVC.modalPresentationStyle = .popover
        newPracticeVC.categories = categories
        
        present(newPracticeVC, animated: true)
    }
    
    @objc private func irregularButtonTapped() {
        let newIrregularVC = NewIrregularViewController()
        newIrregularVC.modalPresentationStyle = .popover
        newIrregularVC.categories = categories
        
        present(newIrregularVC, animated: true)
    }
}
