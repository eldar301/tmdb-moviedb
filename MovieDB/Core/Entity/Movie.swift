//
//  Movie.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

struct Movie {
    let id: Int
    var title: String?
    var overview: String?
    var runtime: Int?
    var genres: [Genre]?
    var releaseDate: Date?
    var posterURL: URL?
    var backdropURL: URL?
    var trailerURL: URL?
    var budget: Int?
    var voteAverage: Double?
    var voteCount: Int?
    var favorite: Bool?
    
    var persons: [Person]?
    var reviews: [Review]?
    
    init(id: Int) {
        self.id = id
    }
}
