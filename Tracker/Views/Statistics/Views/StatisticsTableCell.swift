//
//  StatisticsTableCell.swift
//  Tracker
//
//  Created by Дмитрий on 24.08.2024.
//

import UIKit

final class StatisticsTableCell: UITableViewCell {
    static let reuseIdentifier = "StatisticsTableCell"
    
    private lazy var containerView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var whiteBackgroundView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .ypWhite
        view.layer.cornerRadius = 16
        
        return view
    }()
    
    private lazy var statistic: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .ypBlack
        
        return label
    }()
    
    private lazy var statisticName: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layoutIfNeeded()
        containerView.addGradientBorder(colors: [UIColor.ypRed.cgColor,
                                                 UIColor.ypColorSelection9.cgColor,
                                                 UIColor.ypBlue.cgColor], width: 2)
    }
    
    func configure(statisticCount: Int, statisticName: StatisticsName) {
        statistic.text = "\(statisticCount)"
        
        switch statisticName {
        case .trackersCount: self.statisticName.text = getTrackerString(for: statisticCount)
        }
    }
    
    private func setupViews() {
        
        contentView.setupView(containerView)
        
        containerView.setupView(whiteBackgroundView)
        
        whiteBackgroundView.setupView(statistic)
        whiteBackgroundView.setupView(statisticName)
        
        // Констрейнты
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 90),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            whiteBackgroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            whiteBackgroundView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            whiteBackgroundView.topAnchor.constraint(equalTo: containerView.topAnchor),
            whiteBackgroundView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            statistic.leadingAnchor.constraint(equalTo: whiteBackgroundView.leadingAnchor, constant: 12),
            statistic.topAnchor.constraint(equalTo: whiteBackgroundView.topAnchor, constant: 12),
            
            statisticName.leadingAnchor.constraint(equalTo: statistic.leadingAnchor),
            statisticName.bottomAnchor.constraint(equalTo: whiteBackgroundView.bottomAnchor, constant: -12)
        ])
    }
    
    func getTrackerString(for number: Int) -> String {
        let remainder10 = number % 10
        let remainder100 = number % 100
        
        if remainder100 >= 11 && remainder100 <= 14 {
            return "Трекеров завершено"
        } else {
            switch remainder10 {
            case 1:
                return "Трекер завершен"
            case 2, 3, 4:
                return "Трекера завершено"
            default:
                return "Трекеров завершено"
            }
        }
    }
}
