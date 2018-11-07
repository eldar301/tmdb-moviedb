//
//  RemoteMoviesProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 21/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

class RemoteMoviesProvider: MoviesProvider {
    
    private let networkHelper: NetworkHelper
    
    init(networkHelper: NetworkHelper) {
        self.networkHelper = networkHelper
    }
    
    private var pagedProvider: PagedProvider<MovieRS>?
    
    func fetchMovies(withGenres genres: [Genre], ratingGreaterThan: Double, ratingLowerThan: Double, fromYear: Int, toYear: Int, sortBy: SortBy, completion: @escaping (Result<[Movie]>) -> ()) {
        let request = PaginationSearchAPI.detailedSearch(genres: genres,
                                                         ratingRange: ratingGreaterThan ... ratingLowerThan,
                                                         yearRange: fromYear ... toYear,
                                                         sortBy: sortBy)
        fetch(request: request, completion: completion)
    }
    
    func fetchMovies(withTitle title: String, completion: @escaping (Result<[Movie]>) -> ()) {
        let request = PaginationSearchAPI.search(title: title)
        fetch(request: request, completion: completion)
    }
    
    func fetchTopRatedMovies(completion: @escaping (Result<[Movie]>) -> ()) {
        let request = PaginationSearchAPI.topRated
        fetch(request: request, completion: completion)
    }
    
    func fetchPopularMovies(completion: @escaping (Result<[Movie]>) -> ()) {
        let request = PaginationSearchAPI.popular
        fetch(request: request, completion: completion)
    }
    
    func fetchUpcomingMovies(completion: @escaping (Result<[Movie]>) -> ()) {
        let request = PaginationSearchAPI.upcoming
        fetch(request: request, completion: completion)
    }
    
    private func fetch(request: PaginationSearchAPI, completion: @escaping (Result<[Movie]>) -> ()) {
        pagedProvider = PagedProvider(apiEndpoint: request, networkHelper: networkHelper)
        pagedProvider?.fetchNext(completion: completion)
    }
    
    func fetchNext(completion: @escaping (Result<[Movie]>) -> ()) {
        pagedProvider?.fetchNext(completion: completion)
    }
    
}
