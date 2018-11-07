//
//  RemoteRandomMovieProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 27/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

class RemoteRandomMovieProvider: RandomMovieProvider {
    
    private let moviesProvider: MoviesProvider
    
    init(moviesProvider: MoviesProvider) {
        self.moviesProvider = moviesProvider
    }
    
    func fetch(completion: @escaping (Result<Movie>) -> ()) {
        let genre = Genre.allCases.randomElement()!
        let rgt = 3.0
        let rlt = 5.0
        let fromYear = Int.random(in: 1970 ... 2018)
        let toYear = fromYear + Int.random(in: 0 ... 50)
        let sortBy = SortBy.allCases.randomElement()!
        
        moviesProvider
            .fetchMovies(withGenres: [genre],
                         ratingGreaterThan: rgt,
                         ratingLowerThan: rlt,
                         fromYear: fromYear,
                         toYear: toYear,
                         sortBy: sortBy)
        { result in
            switch result {
            case .success(let movies):
                if let movie = movies.filter({ $0.overview != nil }).randomElement() ?? movies.first {
                    completion(.success(movie))
                } else {
                    completion(.error("Error, refresh the page"))
                }
                
            case .error(let description):
                completion(.error(description))
            }
        }
    }
    
}
