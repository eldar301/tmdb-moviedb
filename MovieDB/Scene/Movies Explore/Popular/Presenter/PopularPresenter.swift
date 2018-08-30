//
//  PopularPresenter.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 22/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

typealias PopularView = MoviesExploreView

protocol PopularPresenter: MoviesExplorePresenter {
    func configurator(forIndex: Int) -> PopularCellConfigurator
}

struct PopularCellConfigurator {
    
    let title: String?
    let posterURL: URL?
    
    fileprivate init(movie: Movie) {
        self.title = movie.title
        self.posterURL = movie.posterURL ?? movie.backdropURL
    }
    
}

class PopularPresenterDefault: PopularPresenter, MovieDetailsPresenterInput {
    
    fileprivate let moviesProvider: MoviesProvider
    
    fileprivate let router: Router
    
    init(router: Router, moviesProvider: MoviesProvider) {
        self.router = router
        self.moviesProvider = moviesProvider
    }
    
    private(set) var selectedMovie: Movie?
    
    fileprivate var movies: [Movie] = []
    
    var moviesCount: Int {
        return movies.count
    }
    
    weak var view: MoviesExploreView?
    
    func refresh() {
        moviesProvider.fetchPopularMovies { [weak self] result in
            if let strongSelf = self {
                strongSelf.handleRequestResult(moviesOut: &strongSelf.movies, result: result, refreshed: true)
            }
        }
    }
    
    func requestNext() {
        moviesProvider.fetchNext { [weak self] result in
            if let strongSelf = self {
                strongSelf.handleRequestResult(moviesOut: &strongSelf.movies, result: result, refreshed: false)
            }
        }
    }
    
    func configurator(forIndex index: Int) -> PopularCellConfigurator {
        return PopularCellConfigurator(movie: movies[index])
    }
    
    func showDetails(ofMovieWithIndex index: Int) {
        selectedMovie = movies[index]
        router.showMovieDetailsScene(fromMovieDetailsPresenterInput: self)
    }
    
}
