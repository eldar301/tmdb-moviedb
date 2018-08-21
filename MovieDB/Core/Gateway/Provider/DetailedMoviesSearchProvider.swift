//
//  DetailedMoviesSearchProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

enum SortBy: String {
    case popularityAscending  = "popularity.asc"
    case popularityDescending = "popularity.desc"
    case ratingAscending      = "vote_average.asc"
    case ratingDescending     = "vote_average.desc"
    case yearAscending        = "release_date.asc"
    case yearDescending       = "release_date.desc"
}

protocol DetailedMoviesSearchProvider {
    func fetchMovies(withGenres: [Genre], ratingGreaterThan: Double, ratingLowerThan: Double, fromYear: Int, toYear: Int, sortBy: SortBy, completition: @escaping (Result<[Movie]>) -> ())
    func fetchNext(completition: @escaping (Result<[Movie]>) -> ())
}
