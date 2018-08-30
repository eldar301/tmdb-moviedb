//
//  Router.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 27/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation
import UIKit

class Router {
    
    fileprivate weak var currentViewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.currentViewController = viewController
    }
    
    func showMovieDetailsScene(fromMovieDetailsPresenterInput input: MovieDetailsPresenterInput) {
        let networkHelper = NetworkHelperDefault()
        let movieDetailsProvider = RemoteMovieDetailsProvider(networkHelper: networkHelper)
        
        guard let presenter = MovieDetailsPresenterDefault(input: input, provider: movieDetailsProvider) else {
            return
        }
        
        let movieDetailsVC = UIStoryboard(name: "MovieDetailsStoryboard", bundle: nil).instantiateInitialViewController() as! MovieDetailsViewController
        
        movieDetailsVC.presenter = presenter
        
        present(childVC: movieDetailsVC)
    }
    
    func showGenreExplorer(output: GenreExplorerPresenterOutput) {
        let presenter = GenreExplorerPresenterDefault(output: output)
        
        let genreExplorerVC = UIStoryboard(name: "GenreExplorerStoryboard", bundle: nil).instantiateInitialViewController() as! GenreExplorerViewController
        
        genreExplorerVC.presenter = presenter
        
        present(childVC: genreExplorerVC)
    }
    
    fileprivate func present(childVC: UIViewController) {
        if let navVC = currentViewController?.navigationController {
            navVC.pushViewController(childVC, animated: true)
        } else {
            currentViewController?.present(childVC, animated: true)
        }
    }
    
}
