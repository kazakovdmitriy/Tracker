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
    
    func addGradientBorder(colors: [CGColor], width: CGFloat) {
        // Удаляем старые градиентные слои, если они есть
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        
        // Создаем градиентный слой
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = bounds
        
        // Создаем обрезной слой
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: width / 2, dy: width / 2), cornerRadius: layer.cornerRadius)
        let borderPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
        borderPath.append(path)
        borderPath.usesEvenOddFillRule = true
        maskLayer.path = borderPath.cgPath
        maskLayer.fillRule = .evenOdd
        gradientLayer.mask = maskLayer
        
        // Добавляем градиентный слой к view
        layer.addSublayer(gradientLayer)
    }
}
