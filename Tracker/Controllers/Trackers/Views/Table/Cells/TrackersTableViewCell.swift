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
    
    func configure(with title: String) {
        textLabel?.text = title
    }
    
    func setSubtitle(with text: String) {
        detailTextLabel?.text = text
    }
    
    private func setupCell() {
        accessoryType = .disclosureIndicator
        backgroundColor = .ypBackground
        textLabel?.textColor = .ypBlack
    }
}
