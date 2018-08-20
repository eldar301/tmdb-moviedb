//
//  MoviesSearchProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

protocol MoviesSearchProviderDelegate: class {
    func moviesSearch(movies: [Movie])
}

protocol MoviesSearchProvider {
    func fetchMovies(withTitle: String)
    func fetchNext()
}
