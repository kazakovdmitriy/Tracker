//
//  UISearchBar + ext.swift
//  Tracker
//
//  Created by Дмитрий on 20.06.2024.
//

import UIKit

public extension UISearchBar {

    func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
}
