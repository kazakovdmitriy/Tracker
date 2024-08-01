//
//  TrackersTableViewDelegate.swift
//  Tracker
//
//  Created by Дмитрий on 29.06.2024.
//

import UIKit

final class TrackersTableViewDelegate: NSObject {
    
    weak var view: UIViewController?
    var data: [String] = []
    var trackersCategory: [String] = []
    var weekDaysSchedule: [WeekDays] = []
    var choiseCategory: String?
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
        
        if let view = view as? NewPracticeViewController {
            if indexPath.row == 0 {
                let choiseCategoryVC = CategoryViewController()
                choiseCategoryVC.tableCategory = trackersCategory
                choiseCategoryVC.delegate = view
                view.present(choiseCategoryVC, animated: true)
            } else if indexPath.row == 1 {
                let scheduleViewController = ScheduleViewController(activatedSwitches: weekDaysSchedule)
                scheduleViewController.modalPresentationStyle = .popover
                scheduleViewController.delegate = view
                view.present(scheduleViewController, animated: true)
            }
        } else if let view = view as? NewIrregularViewController {
            // Обработка для NewIrregularViewController
            if indexPath.row == 0 {
                let choiseCategoryVC = CategoryViewController()
                choiseCategoryVC.tableCategory = trackersCategory
                view.present(choiseCategoryVC, animated: true)
            }
        } else {
            return
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackersTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? TrackersTableViewCell
        else {
            return UITableViewCell()
        }
        
        if indexPath.row == 0 {
            cell.configure(with: data[indexPath.row])
            
            if let choiseCategory {
                cell.setSubtitle(with: choiseCategory)
            }
        }
        
        if indexPath.row == 1 {
            cell.configure(with: data[indexPath.row])
            cell.setSubtitle(with: convertWeekDaysToString(weekDaysSchedule))
        }
        
        return cell
    }
    
    private func convertWeekDaysToString(_ weekDays: [WeekDays]) -> String {
        let weekDaysMap: [WeekDays: String] = [
            .monday: "ПН",
            .tuesday: "ВТ",
            .wednesday: "СР",
            .thursday: "ЧТ",
            .friday: "ПТ",
            .saturday: "СБ",
            .sunday: "ВС",
            .none: ""
        ]
        
        let orderedWeekDays: [WeekDays] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        
        let sortedWeekDays = weekDays.sorted { orderedWeekDays.firstIndex(of: $0)! < orderedWeekDays.firstIndex(of: $1)! }
        let weekDaysStrings = sortedWeekDays.compactMap { weekDaysMap[$0] }
        
        if weekDaysStrings.count == 7 {
            return "Каждый день"
        } else {
            return weekDaysStrings.joined(separator: ", ")
        }
    }
}
