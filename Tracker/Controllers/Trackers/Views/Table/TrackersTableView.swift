//
//  TrackersTableView.swift
//  Tracker
//
//  Created by Дмитрий on 30.06.2024.
//

import UIKit

final class TrackersTableView<CellType: UITableViewCell>: UITableView {
    
    init(cellType: CellType.Type, cellIdentifier: String) {
        super.init(frame: .zero,
                   style: .plain)
        
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        self.isScrollEnabled = false
        self.separatorStyle = .singleLine
        self.separatorColor = .ypBackground
        
        self.register(cellType, forCellReuseIdentifier: cellIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
