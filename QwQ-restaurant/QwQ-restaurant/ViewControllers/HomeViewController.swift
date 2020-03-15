//
//  HomeViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class HomeViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = Constants.tabBarHeight
        tabFrame.origin.y = self.view.frame.size.height - Constants.tabBarHeight
        self.tabBar.frame = tabFrame
    }
}
