//
//  GenreExplorerViewController.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 29/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

class GenreExplorerViewController: UIViewController {
    
    var presenter: GenreExplorerPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        let configurator = presenter.configurator()
    }

}
