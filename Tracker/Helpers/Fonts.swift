//
//  Fonts.swift
//  Tracker
//
//  Created by Дмитрий on 14.07.2024.
//

import UIKit

enum Fonts {
    static func sfPro(with size: CGFloat, _ weight: UIFont.Weight = .regular) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: weight)
    }
}
