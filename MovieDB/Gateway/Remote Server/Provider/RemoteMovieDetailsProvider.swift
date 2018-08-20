//
//  RemoteMovieDetailsProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

class RemoteMovieDetailsProvider: MovieDetailsProvider {
    
    private weak var delegate: MovieDetailsProviderDelegate?
    
    func detailsFor(movieID id: Int) {
        let request = MovieAPI.fullData(movieID: id).urlRequest
    }
    
}
