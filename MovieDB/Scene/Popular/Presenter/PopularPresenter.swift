//
//  PopularPresenter.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 22/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

protocol PopularView: class {
    func updateWithNewMovies()
    func updateWithAdditionalMovies()
    func showError(description: String)
}

struct PopularCellConfigurator {
    
    let title: String?
    let posterURL: URL?
    
    fileprivate init(movie: Movie) {
        self.title = movie.title
        self.posterURL = movie.posterURL ?? movie.backdropURL
    }
    
}

protocol PopularPresenter: class {
    
    var view: PopularView? { get set }
    
    var moviesCount: Int { get }
    
    func refresh()
    func requestNext()
    func configurator(forIndex: Int) -> PopularCellConfigurator
    func showDetails(ofMovieWithIndex: Int)
    
}

class PopularPresenterDefault: PopularPresenter, MovieDetailsPresenterInput {
    
    fileprivate let popularMoviesProvider: PopularMoviesProvider
    
    fileprivate let router: Router
    
    init(router: Router, popularMoviesProvider: PopularMoviesProvider) {
        self.router = router
        self.popularMoviesProvider = popularMoviesProvider
    }
    
    private(set) var selectedMovie: Movie?
    
    fileprivate var movies: [Movie] = []
    
    var moviesCount: Int {
        return movies.count
    }
    
    weak var view: PopularView?
    
    func refresh() {
        popularMoviesProvider.fetchMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                self?.view?.updateWithNewMovies()
                
            case .error(let description):
                self?.view?.showError(description: description)
            }
        }
    }
    
    func requestNext() {
        popularMoviesProvider.fetchNext { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies += movies
                self?.view?.updateWithAdditionalMovies()
                
            case .error(let description):
                self?.view?.showError(description: description)
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
