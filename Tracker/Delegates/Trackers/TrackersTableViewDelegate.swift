//
//  TrackersTableViewDelegate.swift
//  Tracker
//
//  Created by Дмитрий on 29.06.2024.
//

import UIKit

final class TrackersTableViewDelegate: NSObject {
    
    weak var view: CreateBaseController?
    var data: [String] = []
}

// MARK: - TrackersTableViewDelegate
extension TrackersTableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.modalPresentationStyle = .popover
            
            view?.present(scheduleViewController, animated: true)
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

// MARK: - TrackersTableViewDataSource
extension TrackersTableViewDelegate: UITableViewDataSource {
        
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
