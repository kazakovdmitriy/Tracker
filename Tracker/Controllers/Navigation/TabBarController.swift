//
//  TabBarController.swift
//  Tracker
//
//  Created by Дмитрий on 20.06.2024.
//

import UIKit

enum Tabs: Int, CaseIterable {
    case trackers
    case statistics
}

final class SeparatorView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let lineLayer = CALayer()
        lineLayer.frame = CGRect(x: 0, y: 0, width: rect.width, height: 1.0)
        lineLayer.backgroundColor = UIColor.ypBackground.cgColor
        layer.addSublayer(lineLayer)
    }
}

final class TabBarController: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        configureAppearance()
        switchTo(tab: .trackers)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func switchTo(tab: Tabs) {
        selectedIndex = tab.rawValue
    }
    
    private func configureAppearance() {
        tabBar.tintColor = UIColor.ypBlue
        tabBar.barTintColor = UIColor.ypGray
        tabBar.backgroundColor = UIColor.ypWhite
        
        let separator = SeparatorView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1.0))
        tabBar.addSubview(separator)
        
        let controllers: [NavBarController] = Tabs.allCases.map { tab in
            let controller = NavBarController(rootViewController: getController(for: tab))
            controller.tabBarItem = UITabBarItem(title: Strings.TabBar.title(for: tab),
                                                 image: Images.TabBar.icon(for: tab),
                                                 tag: tab.rawValue)
            return controller
        }
        
        setViewControllers(controllers, animated: false)
    }
    
    private func getController(for tab: Tabs) -> UIViewController {
        switch tab {
        case .trackers: return TrackersViewController()
        case .statistics: return StatisticsViewController()
        }
    }
}
