//
//  TrackersTableView.swift
//  Tracker
//
//  Created by Дмитрий on 30.06.2024.
//

import UIKit

final class TrackersTableView<CellType: UITableViewCell>: UITableView {
    
    init(cellType: CellType.Type, cellIdentifier: String, isScrollEnable: Bool = false) {
        super.init(frame: .zero,
                   style: .plain)
        
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        self.isScrollEnabled = isScrollEnable
        self.separatorStyle = .singleLine
        self.separatorColor = .ypBackground
        
        self.register(cellType, forCellReuseIdentifier: cellIdentifier)
        
        if UIScreen.main.bounds.height <= 568 {
            alwaysBounceVertical = true
        } else {
            alwaysBounceVertical = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
