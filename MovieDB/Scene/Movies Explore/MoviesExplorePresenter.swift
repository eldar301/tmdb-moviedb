//
//  MoviesExplorePresenter.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 30/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

protocol MoviesExploreView: class {
    func updateWithNewMovies(movies: [Movie])
    func updateWithAdditionalMovies(movies: [Movie])
    func showError(description: String)
}

protocol MoviesExplorePresenter {
    var view: MoviesExploreView? { get set }
    
    func showDetails(movie: Movie)
}

class MoviesExplorePresenterDefault: MoviesExplorePresenter, MovieDetailsPresenterInput {

    fileprivate let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    private(set) var selectedMovie: Movie?
    
    weak var view: MoviesExploreView?

    func showDetails(movie: Movie) {
        selectedMovie = movie
        router.showMovieDetailsScene(fromMovieDetailsPresenterInput: self)
    }
    
    func handleRequestResult(result: Result<[Movie]>, refreshed: Bool) {
        switch result {
        case .success(let movies):
            if refreshed {
                self.view?.updateWithNewMovies(movies: movies)
            } else {
                self.view?.updateWithAdditionalMovies(movies: movies)
            }
            
        case .error(let description):
            self.view?.showError(description: description)
        }
    }
    
}


