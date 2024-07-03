//
//  CategoryTableViewDelegate.swift
//  Tracker
//
//  Created by Дмитрий on 03.07.2024.
//

import UIKit

final class CategoryTableViewDelegate: NSObject {
    var data: [String] = []
    private var selectedCategoryIndex: Int?
}

extension CategoryTableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        selectedCategoryIndex = indexPath.row
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? CategoryTableViewCell else { return }
        
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

extension CategoryTableViewDelegate: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier, for: indexPath) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        
        let title = data[indexPath.row]
        let isSelected = indexPath.row == selectedCategoryIndex
        
        cell.configure(with: data[indexPath.row], isSelected: isSelected)
        
        return cell
    }
}
