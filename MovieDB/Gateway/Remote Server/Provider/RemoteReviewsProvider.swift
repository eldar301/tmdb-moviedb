//
//  RemoteReviewsProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 21/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

class RemoteReviewsProvider: ReviewsProvider {

    fileprivate let networkHelper: NetworkHelper
    
    init(networkHelper: NetworkHelper) {
        self.networkHelper = networkHelper
    }
    
    fileprivate var pagedProvider: PagedProvider<ReviewRS>?
    
    func fetchReviews(forMovieID movieID: Int, completition: @escaping (Result<[Review]>) -> ()) {
        let request = PaginationSearchAPI.reviews(movieID: movieID)
        pagedProvider = PagedProvider(apiEndpoint: request, networkHelper: networkHelper)
        pagedProvider?.fetchNext(completition: completition)
    }
    
    func fetchNext(completition: @escaping (Result<[Review]>) -> ()) {
        pagedProvider?.fetchNext(completition: completition)
    }
    
}
