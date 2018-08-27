//
//  RemoteMoviesSearchProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 20/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

class RemoteMoviesSearchProvider: MoviesSearchProvider, PagedDelegate {
    
    fileprivate let pagedProvider: PagedProvider<MovieRS>
    
    init(pagedProvider: PagedProvider<MovieRS>) {
        self.pagedProvider = pagedProvider
        pagedProvider.delegate = self
    }
    
    var nextRequest: URLRequest? {
        guard let title = self.title else {
            return nil
        }
        
        return MovieSearchAPI.search(title: title, page: pagedProvider.nextPage).urlRequest
    }
    
    fileprivate var title: String?
    
    func fetchMovies(withTitle title: String, completition: @escaping (Result<[Movie]>) -> ()) {
        self.title = title
        
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
