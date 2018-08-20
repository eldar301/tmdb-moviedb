//
//  MovieDetailsProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

protocol MovieDetailsProviderDelegate: class {
    func movieDetails(movie: Movie)
}

protocol MovieDetailsProvider {
    func detailsFor(movieID: Int)
}
