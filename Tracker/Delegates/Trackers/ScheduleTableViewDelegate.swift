//
//  ScheduleTableViewDelegate.swift
//  Tracker
//
//  Created by Дмитрий on 01.07.2024.
//

import UIKit

final class ScheduleTableViewDelegate: NSObject {
    var data: [String] = []
}

extension ScheduleTableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let cell = tableView.cellForRow(at: indexPath) as? ScheduleTableViewCell {
            cell.cellTapped()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? TrackersTableViewCell else { return }
        
        let totalRows = tableView.numberOfRows(inSection: indexPath.section)
        
        if totalRows == 1 {
            cell.cornerRadius = 16.0
            cell.roundedCorners = [.allCorners]
        } else {
            cell.cornerRadius = 16.0
            if indexPath.row == 0 {
                cell.roundedCorners = [.topLeft, .topRight]
            } else if indexPath.row == totalRows - 1 {
                cell.roundedCorners = [.bottomLeft, .bottomRight]
            } else {
                cell.roundedCorners = []
            }
        }
        
        cell.setNeedsLayout()
    }
}

extension ScheduleTableViewDelegate: UITableViewDataSource {
    func tableView(_ tableView: UITableView, 
                   numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ScheduleTableViewCell()
        
        cell.configure(with: data[indexPath.row], switchId: indexPath.row)
        
        return cell
    }
    
    
}
