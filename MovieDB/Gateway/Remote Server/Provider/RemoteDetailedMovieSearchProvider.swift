//
//  RemoteDetailedMovieSearchProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 20/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

class RemoteDetailedMoviesSearchProvider: DetailedMoviesSearchProvider, PagedDelegate {
    
    fileprivate let pagedProvider: PagedProvider<MovieRS>
    
    init(pagedProvider: PagedProvider<MovieRS>) {
        self.pagedProvider = pagedProvider
        pagedProvider.delegate = self
    }
    
    var nextRequest: URLRequest? {
        guard let genres = self.genres,
        let rgt = self.rgt,
        let rlt = self.rlt,
        let fromYear = self.fromYear,
        let toYear = self.toYear,
        let sortBy = self.sortBy
        
        else {
            return nil
        }
        
        return MovieSearchAPI.detailedSearch(genres: genres, ratingRange: rlt ... rgt, yearRange: fromYear ... toYear, sortBy: sortBy, page: pagedProvider.nextPage).urlRequest
    }
    
    fileprivate var genres: [Genre]?
    fileprivate var rgt: Double?
    fileprivate var rlt: Double?
    fileprivate var fromYear: Int?
    fileprivate var toYear: Int?
    fileprivate var sortBy: SortBy?
    
    func fetchMovies(withGenres genres: [Genre], ratingGreaterThan rgt: Double, ratingLowerThan rlt: Double, fromYear: Int, toYear: Int, sortBy: SortBy, completition: @escaping (Result<[Movie]>) -> ()) {
        self.genres = genres
        self.rgt = rgt
        self.rlt = rlt
        self.fromYear = fromYear
        self.toYear = toYear
        self.sortBy = sortBy
        
        pagedProvider.reset()
        
        fetch(completition: completition)
    }
    
    func fetchNext(completition: @escaping (Result<[Movie]>) -> ()) {
        fetch(completition: completition)
    }
    
    fileprivate func fetch(completition: @escaping (Result<[Movie]>) -> ()) {
        pagedProvider.fetchNext { result in
            switch result {
            case .success(let movies):
                completition(.success(movies.compactMap({ $0.movie })))
                
            case .error(let description):
                completition(.error(description))
            }
        }
    }
    
}
