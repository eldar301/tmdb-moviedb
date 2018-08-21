//
//  RemoteTopRatedMoviesProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 21/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

class RemoteTopRatedMoviesProvider: TopRatedMoviesProvider, PagedDelegate {
    
    var networkHelper: NetworkHelper
    
    init(networkHelper: NetworkHelper) {
        self.networkHelper = networkHelper
    }
    
    fileprivate var pagedProvider = PagedProvider<MovieRS>()
    
    var nextRequest: URLRequest? {
        return MovieSearchAPI.topRated(page: pagedProvider.nextPage).urlRequest
    }
    
    
    func fetchMovies(completition: @escaping (Result<[Movie]>) -> ()) {
        pagedProvider = PagedProvider()
        pagedProvider.delegate = self
        
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
