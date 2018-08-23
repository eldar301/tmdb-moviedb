//
//  MoviesSearchProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

protocol MoviesSearchProvider {
    func fetchMovies(withTitle: String, completition: @escaping (Result<[Movie]>) -> ())
    func fetchNext(completition: @escaping (Result<[Movie]>) -> ())
}
