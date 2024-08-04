//
//  CategroieTableViewCell.swift
//  Tracker
//
//  Created by Дмитрий on 03.07.2024.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CategoryTableViewCell"
    
    var cornerRadius: CGFloat = 0.0
    var roundedCorners: UIRectCorner = []
    
    let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular, scale: .small)
        let image = UIImage(systemName: "checkmark",
                            withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate)
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageView.tintColor = .ypBlue
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
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
    
    func configure(with text: String, isSelected: Bool = false) {
        textLabel?.text = text
        checkmarkImageView.isHidden = !isSelected
    }
    
    private func setupSubviews() {
        contentView.setupView(checkmarkImageView)
        
        NSLayoutConstraint.activate([
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupCell() {
        accessoryType = .disclosureIndicator
        backgroundColor = .ypBackground
        textLabel?.textColor = .ypBlack
        
        accessoryView = checkmarkImageView
    }
}
