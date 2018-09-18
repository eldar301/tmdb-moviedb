//
//  MainViewController.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 01/09/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.barTintColor = UIColor(red: 18.0 / 255.0,
                                           green: 27.0 / 255.0,
                                           blue: 36.0 / 255.0,
                                           alpha: 1.0)
        
        self.tabBar.isTranslucent = false
        
        self.tabBar.tintColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        
        let popularViewController = Router.popularViewController()
        let browseViewController = Router.browseViewController()
        
        self.viewControllers = [popularViewController, browseViewController]
    }

}
