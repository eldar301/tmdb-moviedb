//
//  DetailedMoviesSearchProvider.swift
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

protocol DetailedMoviesSearchProvider {
    func fetchMovies(withGenres: [Genre], ratingGreaterThan: Double, ratingLowerThan: Double, fromYear: Int, toYear: Int, sortBy: SortBy, completition: @escaping (Result<[Movie]>) -> ())
    func fetchNext(completition: @escaping (Result<[Movie]>) -> ())
}
