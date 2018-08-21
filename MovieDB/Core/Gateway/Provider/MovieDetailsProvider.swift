//
//  MovieDetailsProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

typealias MovieDetails = (movie: Movie, reviews: [Review], persons: [Person])

protocol MovieDetailsProvider {
    func details(forMovieID: Int, completition: @escaping (Result<MovieDetails>) -> ())
}
