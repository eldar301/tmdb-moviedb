//
//  MoviesProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

enum SortBy: String, CaseIterable {
    case popularityAscending    = "Popularity ascending"
    case popularityDescending   = "Popularity descending"
    case ratingAscending        = "Rating ascending"
    case ratingDescending       = "Rating descending"
    case yearAscending          = "Year ascending"
    case yearDescending         = "Year descending"
    
    var localizedString: String {
        return NSLocalizedString(self.rawValue, comment: "DetailedMoviesSearchProvider.SortBy")
    }
}

protocol MoviesProvider {
    func fetchMovies(withGenres: [Genre], ratingGreaterThan: Double, ratingLowerThan: Double, fromYear: Int, toYear: Int, sortBy: SortBy, completion: @escaping (Result<[Movie]>) -> ())
    func fetchMovies(withTitle: String, completion: @escaping (Result<[Movie]>) -> ())
    func fetchTopRatedMovies(completion: @escaping (Result<[Movie]>) -> ())
    func fetchPopularMovies(completion: @escaping (Result<[Movie]>) -> ())
    func fetchUpcomingMovies(completion: @escaping (Result<[Movie]>) -> ())
    func fetchNext(completion: @escaping (Result<[Movie]>) -> ())
}
