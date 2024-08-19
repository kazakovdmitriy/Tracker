//
//  SeparatorVIew.swift
//  Tracker
//
//  Created by Дмитрий on 11.08.2024.
//

import UIKit

final class SeparatorView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let lineLayer = CALayer()
        lineLayer.frame = CGRect(x: 0, y: 0, width: rect.width, height: 1.0)
        lineLayer.backgroundColor = UIColor.ypBackground.cgColor
        layer.addSublayer(lineLayer)
    }
}
