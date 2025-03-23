//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Алина on 23.03.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    static let identifier = "TabBarViewController" // Используем как идентификатор
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imagesListVC = ImagesListViewController()
        let profileVC = ProfileViewController()
        
        let imagesNavVC = UINavigationController(rootViewController: imagesListVC)
        imagesListVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named:"tab_editorial_active"), tag: 0)
        
        let profileNavVC = UINavigationController(rootViewController: profileVC)
        profileVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named:"tab_profile_active"), tag: 1)
        
        viewControllers = [imagesNavVC, profileNavVC]
        
        setupTabBarController()
    }
    
    private func setupTabBarController(){
        tabBar.barTintColor = .ypLightBlack
        tabBar.isTranslucent = false
        tabBar.tintColor = .ypWhite
        tabBar.unselectedItemTintColor = .ypDarkGray
        view.backgroundColor = .ypLightBlack
    }
}
