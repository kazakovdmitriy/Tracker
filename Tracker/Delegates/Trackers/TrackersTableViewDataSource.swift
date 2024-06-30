//
//  TrackersTableViewDataSource.swift
//  Tracker
//
//  Created by Дмитрий on 29.06.2024.
//

import UIKit

final class TrackersTableViewDataSource: NSObject, UITableViewDataSource {
    
    var data: [String] = []
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TrackersTableViewCell()
        
        cell.configure(with: data[indexPath.row])
        
        return cell
    }
    
}

