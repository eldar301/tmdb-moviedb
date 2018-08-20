//
//  MoviesProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

protocol MoviesProviderDelegate: class {
    func movies(movies: [Movie])
}

protocol MoviesProvider {
    func fetchMovies()
    func fetchNext()
}
