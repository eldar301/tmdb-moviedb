//
//  TrailerPlayerPresenter.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 08/11/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

protocol TrailerPlayerPresenterInput {
    var selectedMovie: Movie? { get }
}

protocol TrailerPlayerPresenter {
    var trailerID: String { get }
}

class TrailerPlayerPresenterDefault: TrailerPlayerPresenter {
    
    private(set) var trailerID: String
    
    init?(input: TrailerPlayerPresenterInput) {
        guard let trailerID = input.selectedMovie?.trailerID else {
            return nil
        }
        
        self.trailerID = trailerID
    }
    
}
