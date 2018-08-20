//
//  ReviewsProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

protocol ReviewsProviderDelegate: class {
    func reviews(reviews: [Review])
}

protocol ReviewsProvider {
    func fetchReviews(forMovieID: Int)
    func fetchNext()
}
