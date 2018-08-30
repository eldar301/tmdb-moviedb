//
//  RemotePopularMoviesProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 21/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

class RemotePopularMoviesProvider: PopularMoviesProvider, PagedDelegate {
    
    fileprivate let pagedProvider: PagedProvider<MovieRS>
    
    init(pagedProvider: PagedProvider<MovieRS>) {
        self.pagedProvider = pagedProvider
        pagedProvider.delegate = self
    }
    
    var nextRequest: URLRequest? {
        return MovieSearchAPI.popular(page: pagedProvider.nextPage).urlRequest
    }
    
    func fetchMovies(completition: @escaping (Result<[Movie]>) -> ()) {
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
                completition(.success(movies.compactMap({ $0.entity })))
                
            case .error(let description):
                completition(.error(description))
            }
        }
    }
    
}
