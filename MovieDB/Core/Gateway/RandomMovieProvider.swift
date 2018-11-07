//
//  RandomMovieProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 27/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

protocol RandomMovieProvider {
    func fetch(completion: @escaping (Result<Movie>) -> ())
}
