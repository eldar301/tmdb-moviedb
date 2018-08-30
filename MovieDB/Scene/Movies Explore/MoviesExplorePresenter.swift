//
//  MoviesExplorePresenter.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 30/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

protocol MoviesExploreView: class {
    func updateWithNewMovies()
    func updateWithAdditionalMovies()
    func showError(description: String)
}

protocol MoviesExplorePresenter: class {
    
    var view: MoviesExploreView? { get set }
    
    var moviesCount: Int { get }
    
    func refresh()
    func requestNext()
    func showDetails(ofMovieWithIndex: Int)
    
}

extension MoviesExplorePresenter {
    
    func handleRequestResult(moviesOut: inout [Movie], result: Result<[Movie]>, refreshed: Bool) {
        switch result {
        case .success(let movies):
            moviesOut = movies
            DispatchQueue.main.async {
                if refreshed {
                    self.view?.updateWithNewMovies()
                } else {
                    self.view?.updateWithAdditionalMovies()
                }
            }
            
        case .error(let description):
            DispatchQueue.main.async {
                self.view?.showError(description: description)
            }
        }
    }
    
}
