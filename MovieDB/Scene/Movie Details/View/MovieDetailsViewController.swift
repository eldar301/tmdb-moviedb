//
//  MovieDetailsViewController.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 22/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extendedLayoutIncludesOpaqueBars = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.navigationController?.navigationBar.alpha = 1.0
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
