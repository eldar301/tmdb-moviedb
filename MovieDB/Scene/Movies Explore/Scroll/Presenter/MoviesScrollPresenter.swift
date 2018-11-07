//
//  PopularPresenter.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 22/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

enum Category {
    case popular
    case topRated
}

protocol ScrollPresenter {
    
    var category: Category { get }
    
    func request()
    func requestNext()
}

typealias MoviesScrollPresenter = MoviesExplorePresenter & ScrollPresenter

class MoviesScrollPresenterDefault: MoviesExplorePresenterDefault, ScrollPresenter {

    private let moviesProvider: MoviesProvider
    let category: Category

    init(router: Router, moviesProvider: MoviesProvider, category: Category) {
        self.moviesProvider = moviesProvider
        self.category = category
        super.init(router: router)
    }
    
    func request() {
        let completion: (Result<[Movie]>) -> () = { [weak self] result in
            self?.handleRequestResult(result: result, refreshed: true)
        }
        
        switch category {
        case .popular:
            moviesProvider.fetchPopularMovies(completion: completion)
        case .topRated:
            moviesProvider.fetchTopRatedMovies(completion: completion)
        }
    }
    
    func requestNext() {
        moviesProvider.fetchNext { [weak self] result in
            self?.handleRequestResult(result: result, refreshed: false)
        }
    }
    
}
