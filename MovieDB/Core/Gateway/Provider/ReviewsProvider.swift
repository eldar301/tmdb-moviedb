//
//  ReviewsProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

protocol ReviewsProvider {
    func fetchReviews(forMovieID: Int, completition: @escaping (Result<[Review]>) -> ())
    func fetchNext(completition: @escaping (Result<[Review]>) -> ())
}
