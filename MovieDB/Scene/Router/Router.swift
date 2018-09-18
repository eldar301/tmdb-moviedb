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
        
        let movieDetailsVC = UIStoryboard(name: "MovieDetailsStoryboard", bundle: nil).instantiateInitialViewController() as! MovieDetailsViewController
        
        let router = Router(viewController: movieDetailsVC)
        
        guard let presenter = MovieDetailsPresenterDefault(router: router, input: input, provider: movieDetailsProvider) else {
            return
        }
        
        
        movieDetailsVC.presenter = presenter
        
        let navVC = UINavigationController(rootViewController: movieDetailsVC)
        
        presentModally(childVC: navVC)
//        present(childVC: movieDetailsVC)
    }
    
    func showGenreExplorer(input: DetailedMovieSearchPresenterInput) {
        let detailedMovieSearchVC = DetailedMovieSearchViewController()
        
        let router = Router(viewController: detailedMovieSearchVC)
        
        let networkHelper = NetworkHelperDefault()
        let moviesProvider = RemoteMoviesProvider(networkHelper: networkHelper)
        
        let presenter = DetailedMovieSeachPresenterDefault(router: router, moviesProvider: moviesProvider, input: input)
        
        detailedMovieSearchVC.presenter = presenter
        
        present(childVC: detailedMovieSearchVC)
    }
    
    func showDetailedSearchSettings(input: DetailedSearchSettingsPresenterInput, output: DetailedSearchSettingsPresenterOutput) {
        let detailedSearchSettingsVC = DetailedSearchSettingsViewController()
        detailedSearchSettingsVC.modalPresentationStyle = .popover
        
        let router = Router(viewController: detailedSearchSettingsVC)
        
        let presenter = DetailedSearchSettingsPresenterDefault(router: router, input: input, output: output)
        
        detailedSearchSettingsVC.presenter = presenter
        
        presentModally(childVC: detailedSearchSettingsVC)
    }
    
    func loadSearchResultsScene() {
        let titleMovieSearchVC = TitleMovieSearchViewController()
        
        let router = Router(viewController: titleMovieSearchVC)
        
        let networkHelper = NetworkHelperDefault()
        let moviesProvider = RemoteMoviesProvider(networkHelper: networkHelper)
        let presenter = TitleMovieSearchPresenterDefault(router: router, moviesProvider: moviesProvider)
        
        titleMovieSearchVC.presenter = presenter
        
        let searchController = UISearchController(searchResultsController: titleMovieSearchVC)
        searchController.searchResultsUpdater = currentViewController as? UISearchResultsUpdating
        searchController.searchBar.delegate = currentViewController as? UISearchBarDelegate
        searchController.searchBar.barStyle = .black
        searchController.searchBar.tintColor = .white
        searchController.searchBar.placeholder = "Title"
        currentViewController?.navigationItem.searchController = searchController
    }
    
    func dismiss() {
        if let navVC = currentViewController?.navigationController, navVC.viewControllers[0] != currentViewController {
            navVC.popViewController(animated: true)
        } else {
            currentViewController?.dismiss(animated: true)
        }
    }
    
    fileprivate func present(childVC: UIViewController, animated: Bool = true) {
        if let navVC = currentViewController?.navigationController {
            navVC.pushViewController(childVC, animated: true)
        } else {
            currentViewController?.present(childVC, animated: true)
        }
    }
    
    fileprivate func presentModally(childVC: UIViewController) {
        currentViewController?.present(childVC, animated: true)
    }
    
}

//extension Router: DetailedSearchSettingsPresenterInput {
//    
//    var selectedGenre: Genre? {
//        return .western
//    }
//    
//    
//}
//
//extension Router: DetailedSearchSettingsPresenterOutput {
//    func setup(fromYear: Int, toYear: Int, fromRating: Double, toRating: Double, sortOptionIndex: SortBy) {
//        
//    }
//    
//    
//}
