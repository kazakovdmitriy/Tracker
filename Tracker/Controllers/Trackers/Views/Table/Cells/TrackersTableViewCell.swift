//
//  TrackersTableViewCell.swift
//  Tracker
//
//  Created by Дмитрий on 29.06.2024.
//

import UIKit

final class TrackersTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TrackersTableViewCell"
    
    var cornerRadius: CGFloat = 0.0
    var roundedCorners: UIRectCorner = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
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
    
    private func setupCell() {
        self.accessoryType = .disclosureIndicator
        self.backgroundColor = .ypBackground
        self.textLabel?.textColor = .ypBlack
    }
    
    func configure(with title: String) {
        self.textLabel?.text = title
    }
    
    func setSubtitle(with text: String) {
        self.detailTextLabel?.text = text
    }
}
