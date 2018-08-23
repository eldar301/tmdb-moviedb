//
//  MovieDetailsProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

protocol MovieDetailsProvider {
    func details(forMovieID: Int, completition: @escaping (Result<Movie>) -> ())
}
