//
//  NewPractiseViewController.swift
//  Tracker
//
//  Created by Дмитрий on 28.06.2024.
//

import UIKit

final class NewPracticeViewController: CreateBaseController {
    init() {
        super.init(tableCategory: ["Категория", "Расписание"],
                   title: R.Strings.NavTitle.newPractice)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
