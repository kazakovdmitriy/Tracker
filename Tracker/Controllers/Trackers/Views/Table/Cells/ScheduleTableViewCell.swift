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
        self.setupCell()
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
        self.layer.mask = mask
    }
    
    func configure(with text: String, switchId: Int) {
        self.textLabel?.text = text
        self.switchView.tag = switchId
    }
    
    func cellTapped() {
        switchView.setOn(!switchView.isOn, animated: true)
    }
    
    private func setupCell() {
        self.accessoryType = .disclosureIndicator
        self.backgroundColor = .ypBackground
        self.textLabel?.textColor = .ypBlack
        
        self.accessoryView = switchView
    }
}
