//
//  MoviesProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

typealias TopRatedMoviesProvider = MoviesProvider
typealias PopularMoviesProvider = MoviesProvider
typealias FavoritesMoviesProvider = MoviesProvider

protocol MoviesProvider {
    func fetchMovies(completition: @escaping (Result<[Movie]>) -> ())
    func fetchNext(completition: @escaping (Result<[Movie]>) -> ())
}
