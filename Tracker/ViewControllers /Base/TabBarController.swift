//
//  TabBarController.swift
//  Tracker
//
//  Created by Andrey Bezrukov on 21.06.2023.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateTabBar()
    }
    
    private func generateTabBar() {
        
        let trackersViewController = generateVC(viewController: UINavigationController(rootViewController: TrackersViewController()),
                                                title: "Трекеры",
                                                image: UIImage(systemName: "record.circle.fill")),
            statisticsViewController = generateVC(viewController: UINavigationController(rootViewController: StatisticsViewController()),
                                                  title: "Статистика",
                                                  image: UIImage(systemName: "hare.fill"))
        
        viewControllers = [trackersViewController, statisticsViewController]
    }
    
    private func generateVC(viewController: UIViewController,
                            title: String,
                            image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        lineView.backgroundColor = UIColor.uiGray
        tabBar.insertSubview(lineView, at: 0)
        
        tabBar.barTintColor = .uiGray
        tabBar.barTintColor = .uiBlue
        tabBar.backgroundColor = .uiWhite
        
        view.backgroundColor = .uiWhite
        
        return viewController
    }
}
