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
    var trackersCategory: [String] = []
    var weekDaysSchedule: [WeekDays] = []
    var choiseCategory: String?
}

// MARK: - TrackersTableViewDelegate
extension TrackersTableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let view = view else { return }
        
        if indexPath.row == 0 {
            presentCategoryViewController(for: view)
        } else if indexPath.row == 1, view is NewPracticeViewController || (view is EditTrackersViewController && (view as! EditTrackersViewController).tracker.type == .practice) {
            presentScheduleViewController(for: view)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? TrackersTableViewCell else { return }
        
        let totalRows = tableView.numberOfRows(inSection: indexPath.section)
        cell.cornerRadius = 16.0
        
        if totalRows == 1 {
            cell.roundedCorners = [.allCorners]
        } else if indexPath.row == 0 {
            cell.roundedCorners = [.topLeft, .topRight]
        } else if indexPath.row == totalRows - 1 {
            cell.roundedCorners = [.bottomLeft, .bottomRight]
        } else {
            cell.roundedCorners = []
        }
        
        cell.setNeedsLayout()
    }
    
    private func presentCategoryViewController(for view: CreateBaseController) {
        let choiseCategoryVM = CategoryViewModel()
        let choiseCategoryVC = CategoryViewController(viewModel: choiseCategoryVM)
        choiseCategoryVC.delegate = view as? CategoryViewControllerDelegate
        view.present(choiseCategoryVC, animated: true)
    }
    
    private func presentScheduleViewController(for view: CreateBaseController) {
        let scheduleViewController = ScheduleViewController(activatedSwitches: weekDaysSchedule)
        scheduleViewController.modalPresentationStyle = .popover
        scheduleViewController.delegate = view as? ScheduleViewControllerDelegate
        view.present(scheduleViewController, animated: true)
    }
}

// MARK: - TrackersTableViewDataSource
extension TrackersTableViewDelegate: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackersTableViewCell.reuseIdentifier, for: indexPath) as? TrackersTableViewCell else {
            return UITableViewCell()
        }
        
        configure(cell, at: indexPath)
        
        return cell
    }
    
    private func configure(_ cell: TrackersTableViewCell, at indexPath: IndexPath) {
        cell.configure(with: data[indexPath.row])
        
        if indexPath.row == 0, let choiseCategory {
            cell.setSubtitle(with: choiseCategory)
        } else if indexPath.row == 1 {
            cell.setSubtitle(with: convertWeekDaysToString(weekDaysSchedule))
        }
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
