//
//  TitleMovieSearchPresenter.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 05/09/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

protocol TitleMovieSearchPresenter {
    
    var view: MoviesExploreView? { get set }
    
    func search(title: String)
    func searchNext()
    
    func showDetails(movie: Movie)
}

class TitleMovieSearchPresenterDefault: MoviesExplorePresenterDefault, TitleMovieSearchPresenter {

    private let router: Router
    private let moviesProvider: MoviesProvider
    
    init(router: Router, moviesProvider: MoviesProvider) {
        self.router = router
        self.moviesProvider = moviesProvider
        super.init(router: router)
    }
    
    func search(title: String) {
        moviesProvider.fetchMovies(withTitle: title) { [weak self] result in
            self?.handleRequestResult(result: result, refreshed: true)
        }
    }
    
    func searchNext() {
        moviesProvider.fetchNext { [weak self] result in
            self?.handleRequestResult(result: result, refreshed: false)
        }
    }
    
}
