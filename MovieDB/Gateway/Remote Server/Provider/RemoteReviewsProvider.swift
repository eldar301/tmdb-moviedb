//
//  RemoteReviewsProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 21/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

class RemoteReviewsProvider: ReviewsProvider, PagedDelegate {

    fileprivate let pagedProvider: PagedProvider<ReviewRS>
    
    init(pagedProvider: PagedProvider<ReviewRS>) {
        self.pagedProvider = pagedProvider
        pagedProvider.delegate = self
    }
    
    var nextRequest: URLRequest? {
        return MovieSearchAPI.topRated(page: pagedProvider.nextPage).urlRequest
    }
    
    func fetchReviews(forMovieID: Int, completition: @escaping (Result<[Review]>) -> ()) {
        pagedProvider.reset()
        
        fetch(completition: completition)
    }
    
    func fetchNext(completition: @escaping (Result<[Review]>) -> ()) {
        fetch(completition: completition)
    }
    
    fileprivate func fetch(completition: @escaping (Result<[Review]>) -> ()) {
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
