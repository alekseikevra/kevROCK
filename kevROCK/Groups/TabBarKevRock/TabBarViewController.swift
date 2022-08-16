//
//  TabBarViewController.swift
//  kevROCK
//
//  Created by Aleksei Kevra on 24.05.2022.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if let items = tabBar.items {
                for item in items {
                    item.setTitleTextAttributes([.foregroundColor: AppColor.kevRock], for: .selected)
                    item.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
                }
            }
        }
    
}

// MARK: - Configure
private extension TabBarViewController {
    
    func configure() {
        configureViewControllers()
        configureTabBar()
    }
    
    func configureViewControllers() {
        
        let mainVC = UIStoryboard(name: "MainStoryboard", bundle: nil).instantiateInitialViewController() as! UINavigationController
        
        let mainTabBarItem = UITabBarItem()
        mainTabBarItem.title = "Main"
        mainTabBarItem.image = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal)
        mainTabBarItem.selectedImage = UIImage(named: "homeSelected")?.withRenderingMode(.alwaysOriginal)
        mainVC.tabBarItem = mainTabBarItem
        
        let searchVC = UIStoryboard(name: "Search", bundle: nil).instantiateInitialViewController() as! UINavigationController

        let searchTabBarItem = UITabBarItem()
        searchTabBarItem.title = "Search"
        searchTabBarItem.image = UIImage(named: "search")?.withRenderingMode(.alwaysOriginal)
        searchTabBarItem.selectedImage = UIImage(named: "searchSelected")?.withRenderingMode(.alwaysOriginal)
        searchVC.tabBarItem = searchTabBarItem
        
        let profileVC = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController() as! UINavigationController
        
        let profileTabBarItem = UITabBarItem()
        profileTabBarItem.title = "Profile"
        profileTabBarItem.badgeColor = .white
        profileTabBarItem.image = UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal)
        profileTabBarItem.selectedImage = UIImage(named: "profileSelected")?.withRenderingMode(.alwaysOriginal)
        profileVC.tabBarItem = profileTabBarItem
        
        viewControllers = [mainVC, searchVC, profileVC]
    }
    
    func configureTabBar() {
        selectedIndex = 0
        let transperentBlackColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.9)
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        transperentBlackColor.setFill()
        UIRectFill(rect)
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            tabBar.backgroundImage = image
        }
    }
    
}

