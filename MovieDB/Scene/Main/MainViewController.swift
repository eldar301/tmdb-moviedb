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
        
        let popularViewController = Router.popularViewController()
        let browseViewController = Router.browseViewController()
        
        self.viewControllers = [popularViewController, browseViewController, Router(viewController: self).showDeailedSearchSettings()]
    }

}
