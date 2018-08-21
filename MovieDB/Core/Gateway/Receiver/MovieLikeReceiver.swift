//
//  MovieLikeReceiver.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 21/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

protocol MovieLikeReceiver {
    func like(movie: Movie, completition: @escaping (Bool) -> ())
    func unlike(forMovieID: Int, completition: @escaping (Bool) -> ())
}
