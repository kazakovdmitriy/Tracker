//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Дмитрий on 01.07.2024.
//

import UIKit

final class ScheduleTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ScheduleTableViewCell"
    
    var cornerRadius: CGFloat = 0.0
    var roundedCorners: UIRectCorner = []
    
    var isActive: Bool {
            return switchView.isOn
        }
    
    let switchView: UISwitch = {
        let switchView = UISwitch()
        
        switchView.setOn(false, animated: true)
        switchView.onTintColor = .ypBlue
        
        return switchView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: roundedCorners,
                                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func configure(with text: String, 
                   isActivate: Bool,
                   switchId: Int
    ) {
        textLabel?.text = text
        switchView.tag = switchId
        switchView.setOn(isActivate, animated: false)
    }
    
    func cellTapped() {
        switchView.setOn(!switchView.isOn, animated: true)
    }
    
    private func setupCell() {
        accessoryType = .disclosureIndicator
        backgroundColor = .ypBackground
        textLabel?.textColor = .ypBlack
        selectionStyle = .none
        
        accessoryView = switchView
    }
}
