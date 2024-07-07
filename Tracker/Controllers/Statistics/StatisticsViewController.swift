//
//  ViewController.swift
//  Tracker
//
//  Created by Дмитрий on 20.06.2024.
//

import UIKit

final class StatisticsViewController: BaseController {
    
    private let statisticsEmptyLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Анализировать пока нечего"
        label.font = R.Fonts.sfPro(with: 12)
        label.textColor = .ypBlack
        label.textAlignment = .center
        
        return label
    }()
    
    private let statisticsEmptyImage: UIImageView = {
        let image = UIImage(named: "empty_statistic_image")
        let view = UIImageView(image: image)
        
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private let containerView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        constraintViews()
        configureAppearance()
    }
}

extension StatisticsViewController {
    override func setupViews() {
        super.setupViews()
        
        containerView.setupView(statisticsEmptyLabel)
        containerView.setupView(statisticsEmptyImage)
        
        view.setupView(containerView)
        
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            statisticsEmptyImage.widthAnchor.constraint(equalToConstant: 80),
            statisticsEmptyImage.heightAnchor.constraint(equalTo: statisticsEmptyImage.widthAnchor),
            statisticsEmptyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            statisticsEmptyLabel.topAnchor.constraint(equalTo: statisticsEmptyImage.bottomAnchor, constant: 15),
            statisticsEmptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statisticsEmptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        setupNavigationBar()
    }
}

private extension StatisticsViewController {
    func setupNavigationBar() {
        // Устанавливаем крупный заголовок
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = R.Strings.NavBar.statistics
    }
}
