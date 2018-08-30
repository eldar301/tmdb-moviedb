//
//  RemoteMoviesProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 21/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

class RemoteMoviesProvider: MoviesProvider {
    
    fileprivate let networkHelper: NetworkHelper
    
    init(networkHelper: NetworkHelper) {
        self.networkHelper = networkHelper
    }
    
    fileprivate var pagedProvider: PagedProvider<MovieRS>?
    
    func fetchMovies(withGenres genres: [Genre], ratingGreaterThan: Double, ratingLowerThan: Double, fromYear: Int, toYear: Int, sortBy: SortBy, completition: @escaping (Result<[Movie]>) -> ()) {
        let request = PaginationSearchAPI.detailedSearch(genres: genres,
                                                         ratingRange: ratingGreaterThan ... ratingLowerThan,
                                                         yearRange: fromYear ... toYear,
                                                         sortBy: sortBy)
        fetch(request: request, completition: completition)
    }
    
    func fetchMovies(withTitle title: String, completition: @escaping (Result<[Movie]>) -> ()) {
        let request = PaginationSearchAPI.search(title: title)
        fetch(request: request, completition: completition)
    }
    
    func fetchTopRatedMovies(completition: @escaping (Result<[Movie]>) -> ()) {
        let request = PaginationSearchAPI.topRated
        fetch(request: request, completition: completition)
    }
    
    func fetchPopularMovies(completition: @escaping (Result<[Movie]>) -> ()) {
        let request = PaginationSearchAPI.popular
        fetch(request: request, completition: completition)
    }
    
    fileprivate func fetch(request: PaginationSearchAPI, completition: @escaping (Result<[Movie]>) -> ()) {
        pagedProvider = PagedProvider(apiEndpoint: request, networkHelper: networkHelper)
        pagedProvider?.fetchNext(completition: completition)
    }
    
    func fetchNext(completition: @escaping (Result<[Movie]>) -> ()) {
        pagedProvider?.fetchNext(completition: completition)
    }
    
}
