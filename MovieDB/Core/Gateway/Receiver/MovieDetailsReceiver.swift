//
//  MovieDetailsReceiver.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

protocol MovieDetailsReceiver {
    func receive(forMovieID: Int, movie: Movie, reviews: [Review], persons: [Person])
}
