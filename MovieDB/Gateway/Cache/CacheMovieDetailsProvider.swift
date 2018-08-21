//
//  CacheMovieDetailsProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 21/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

class CacheMovieDetailsProvider: MovieDetailsProvider {
    
    fileprivate var localStore: MovieDetailsProvider & MovieDetailsReceiver
    fileprivate var remoteStore: MovieDetailsProvider
    
    init(localStore: MovieDetailsProvider & MovieDetailsReceiver, remoteStore: MovieDetailsProvider) {
        self.localStore = localStore
        self.remoteStore = remoteStore
    }
    
    func details(forMovieID movieID: Int, completition: @escaping (Result<Movie>) -> ()) {
        localStore.details(forMovieID: movieID, completition: completition)
        remoteStore.details(forMovieID: movieID) { [weak self] result in
            self?.localStore.details(movie: result)
            completition(result)
        }
    }
    
}
