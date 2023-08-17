//
//  TabBarController.swift
//  Tracker
//
//  Created by Andrey Bezrukov on 21.06.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    private enum TabBarItem: Int {
        case tracker
        case statistic
        
        var title: String {
            switch self {
            case .tracker:
                return NSLocalizedString("trackers", comment: "")
            case .statistic:
                return NSLocalizedString("statistics", comment: "")
            }
        }
        
        var iconName: String {
            switch self {
            case .tracker:
                return "record.circle.fill"
            case .statistic:
                return "hare.fill"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .uiWhite
        
        let dataSource: [TabBarItem] = [.tracker, .statistic]
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        lineView.backgroundColor = UIColor.tabBarBorderLineColor
        tabBar.insertSubview(lineView, at: 0)

        tabBar.barTintColor = .uiGray
        tabBar.barTintColor = .uiBlue
        tabBar.backgroundColor = .uiWhite
        
        self.viewControllers = dataSource.map {
            switch $0 {
            case .tracker:
                return TrackersViewController(trackerStore: TrackerStore())
            case .statistic:
                return StatisticViewController(viewModel: StatisticsViewModel())
            }
        }
        
        viewControllers?.enumerated().forEach {
            $1.tabBarItem.title = dataSource[$0].title
            $1.tabBarItem.image = UIImage(systemName: dataSource[$0].iconName)
        }
    }
}
