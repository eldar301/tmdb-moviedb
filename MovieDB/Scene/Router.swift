//
//  Router.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 27/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation
import UIKit

fileprivate struct Constants {
    struct Storyboards {
        static let moviesScrollStoryBoard = UIStoryboard(name: "MoviesScrollStoryboard", bundle: nil)
        static let browseStoryBoard = UIStoryboard(name: "BrowseStoryboard", bundle: nil)
        static let movieDetailsStoryBoard = UIStoryboard(name: "MovieDetailsStoryboard", bundle: nil)
    }
}

class Router {
    
    private weak var currentViewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.currentViewController = viewController
    }
    
    class func popularViewController() -> UIViewController {
        return scrollViewController(forCategory: .popular)
    }
    
    class func topRatedViewController() -> UIViewController {
        return scrollViewController(forCategory: .topRated)
    }
    
    private class func scrollViewController(forCategory category: Category) -> UIViewController {
        let navVC = Constants.Storyboards.moviesScrollStoryBoard.instantiateInitialViewController() as! UINavigationController
        
        let popularVC = navVC.viewControllers.first as! MoviesScrollViewController
        
        let router = Router(viewController: popularVC)
        
        let networkHelper = NetworkHelperDefault()
        let moviesProvider = RemoteMoviesProvider(networkHelper: networkHelper)
        let presenter = MoviesScrollPresenterDefault(router: router, moviesProvider: moviesProvider, category: category)
        
        popularVC.presenter = presenter
        
        return navVC
    }
    
    class func browseViewController() -> UIViewController {
        let navVC = Constants.Storyboards.browseStoryBoard.instantiateInitialViewController() as! UINavigationController
        
        let browseVC = navVC.viewControllers.first as! BrowseViewController
        
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
        
        let movieDetailsVC = Constants.Storyboards.movieDetailsStoryBoard.instantiateInitialViewController() as! MovieDetailsViewController
        
        let router = Router(viewController: movieDetailsVC)
        
        guard let presenter = MovieDetailsPresenterDefault(router: router, input: input, provider: movieDetailsProvider) else {
            return
        }
        
        movieDetailsVC.presenter = presenter
        
        let navVC = UINavigationController(rootViewController: movieDetailsVC)
        
        presentModally(childVC: navVC)
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
        currentViewController?.navigationItem.searchController = searchController
    }
    
    func showTrailerPlayerScene(input: TrailerPlayerPresenterInput) {
        let trailerPlayerVC = TrailerPlayerViewController()
        
        guard let presenter = TrailerPlayerPresenterDefault(input: input) else {
            return
        }
        
        trailerPlayerVC.presenter = presenter
        
        presentModally(childVC: trailerPlayerVC)
    }
    
    func dismiss() {
        if let navVC = currentViewController?.navigationController, navVC.viewControllers.first != currentViewController {
            navVC.popViewController(animated: true)
        } else {
            currentViewController?.dismiss(animated: true)
        }
    }
    
    private func present(childVC: UIViewController, animated: Bool = true) {
        if let navVC = currentViewController?.navigationController {
            navVC.pushViewController(childVC, animated: true)
        } else {
            currentViewController?.present(childVC, animated: true)
        }
    }
    
    private func presentModally(childVC: UIViewController) {
        currentViewController?.present(childVC, animated: true)
    }
    
}
