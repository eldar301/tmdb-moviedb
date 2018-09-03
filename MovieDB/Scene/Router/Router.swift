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
    
    class func popularViewController() -> UIViewController {
        let navVC = UIStoryboard(name: "PopularStoryboard", bundle: nil).instantiateInitialViewController() as! UINavigationController
        
        let popularVC = navVC.viewControllers[0] as! PopularViewController
        
        let router = Router(viewController: popularVC)

        let networkHelper = NetworkHelperDefault()
        let moviesProvider = RemoteMoviesProvider(networkHelper: networkHelper)
        let presenter = PopularPresenterDefault(router: router, moviesProvider: moviesProvider)

        popularVC.presenter = presenter

        return navVC
    }
    
    class func browseViewController() -> UIViewController {
        let navVC = UIStoryboard(name: "BrowseStoryboard", bundle: nil).instantiateInitialViewController() as! UINavigationController
        
        let browseVC = navVC.viewControllers[0] as! BrowseViewController
        
        let router = Router(viewController: browseVC)
        
        let networkHelper = NetworkHelperDefault()
        let moviesProvider = RemoteMoviesProvider(networkHelper: networkHelper)
        let randomMovieProvider = RemoteRandomMovieProvider(moviesProvider: moviesProvider)
        let presenter = BrowsePresenterDefault(router: router, randomMovieProvider: randomMovieProvider)
        
        browseVC.presenter = presenter
        
        return navVC
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
    
    func showGenreExplorer(input: DetailedSearchSettingsPresenterInput, output: DetailedSearchSettingsPresenterOutput) {
        let presenter = DetailedSearchSettingsPresenterDefault(input: input, output: output)
        
//        let genreExplorerVC = UIStoryboard(name: "GenreExplorerStoryboard", bundle: nil).instantiateInitialViewController() as! GenreExplorerViewController
//
//        genreExplorerVC.presenter = presenter
//
//        present(childVC: genreExplorerVC)
    }
    
    func showDeailedSearchSettings() -> UIViewController {
        let detailedSearchSettingsVC = DetailedSearchSettingsViewController()
        detailedSearchSettingsVC.modalPresentationStyle = .popover
        
        let presenter = DetailedSearchSettingsPresenterDefault(input: self, output: self)
        
        detailedSearchSettingsVC.presenter = presenter
        
//        currentViewController?.present(detailedSearchSettingsVC, animated: true)
        return detailedSearchSettingsVC
    }
    
    fileprivate func present(childVC: UIViewController) {
        if let navVC = currentViewController?.navigationController {
            navVC.pushViewController(childVC, animated: true)
        } else {
            currentViewController?.present(childVC, animated: true)
        }
    }
    
}

extension Router: DetailedSearchSettingsPresenterInput {
    
    var selectedGenre: Genre? {
        return .western
    }
    
    
}

extension Router: DetailedSearchSettingsPresenterOutput {
    func setup(fromYear: Int, toYear: Int, fromRating: Double, toRating: Double, sortOptionIndex: SortBy) {
        
    }
    
    
}
