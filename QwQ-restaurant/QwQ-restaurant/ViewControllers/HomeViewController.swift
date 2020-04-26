//
//  HomeViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 15/3/20.
//

/**
`HomeViewController` represents the home page once a user logs into the application and manages tab bar settings.
 */

import UIKit

class HomeViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if !RestaurantActivity.shared().restaurant.isValidRestaurant {
            showMessage(title: Constants.welcomeMessage,
                        message: Constants.profileSetupMessage,
                        buttonText: Constants.okayTitle)
        }
    }
    
    override func viewDidLayoutSubviews() {
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = Constants.tabBarHeight
        tabFrame.origin.y = self.view.frame.size.height - Constants.tabBarHeight
        self.tabBar.frame = tabFrame
    }
}
