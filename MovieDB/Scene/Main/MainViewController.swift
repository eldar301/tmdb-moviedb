//
//  MainViewController.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 01/09/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let barTintColor = UIColor(red: 18.0 / 255.0,
                                      green: 27.0 / 255.0,
                                      blue: 36.0 / 255.0,
                                      alpha: 1.0)
    static let tintColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
    static let fixingInsetsForEmptyTitleOfTabBarItem = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -10.0, right: 0.0)
}

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.barTintColor = Constants.barTintColor
        
        self.tabBar.isTranslucent = false
        
        self.tabBar.tintColor = Constants.tintColor
        
        let topRatedViewController = Router.topRatedViewController()
        let popularViewController = Router.popularViewController()
        let browseViewController = Router.browseViewController()
        
        self.viewControllers = [topRatedViewController, popularViewController, browseViewController]
        
        for (index, image) in [#imageLiteral(resourceName: "Top Rated Icon Regular"),#imageLiteral(resourceName: "Popular Icon Regular"),#imageLiteral(resourceName: "Browse Icon Regular")].enumerated() {
            self.viewControllers![index].tabBarItem.title = ""
            self.viewControllers![index].tabBarItem.image = image
            self.viewControllers![index].tabBarItem.imageInsets = Constants.fixingInsetsForEmptyTitleOfTabBarItem
        }
        
        selectedIndex = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }

}
