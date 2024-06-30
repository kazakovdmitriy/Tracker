//
//  UIView + ext.swift
//  Tracker
//
//  Created by Дмитрий on 20.06.2024.
//

import UIKit

extension UIView {
    func setupView(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addTopBorder(with color: UIColor?, height: CGFloat) {
        let separator = UIView()
        separator.backgroundColor = color
        separator.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        separator.frame = CGRect(x: 0,
                                 y: 0,
                                 width: frame.width,
                                 height: height)
        
        addSubview(separator)
    }
}

