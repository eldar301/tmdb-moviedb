//
//  RemoteReviewsProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 21/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

class RemoteReviewsProvider: ReviewsProvider, PagedDelegate {

    var networkHelper: NetworkHelper
    
    init(networkHelper: NetworkHelper) {
        self.networkHelper = networkHelper
    }
    
    fileprivate var pagedProvider = PagedProvider<ReviewRS>()
    
    var nextRequest: URLRequest? {
        return MovieSearchAPI.topRated(page: pagedProvider.nextPage).urlRequest
    }
    
    func fetchReviews(forMovieID: Int, completition: @escaping (Result<[Review]>) -> ()) {
        pagedProvider = PagedProvider()
        pagedProvider.delegate = self
        
        fetch(completition: completition)
    }
    
    func fetchNext(completition: @escaping (Result<[Review]>) -> ()) {
        fetch(completition: completition)
    }
    
    fileprivate func fetch(completition: @escaping (Result<[Review]>) -> ()) {
        pagedProvider.fetchNext { result in
            switch result {
            case .success(let movies):
                completition(.success(movies.compactMap({ $0.review })))
                
            case .error(let description):
                completition(.error(description))
            }
        }
    }
    
}
