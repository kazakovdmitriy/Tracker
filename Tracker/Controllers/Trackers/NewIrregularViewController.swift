//
//  NewIrregularViewController.swift
//  Tracker
//
//  Created by Дмитрий on 30.06.2024.
//

import UIKit

final class NewIrregularViewController: CreateBaseController {
    init() {
        super.init(tableCategory: ["Категория"],
                   title: R.Strings.NavTitle.newIrregular)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
