//
//  BrowsePresenter.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 27/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

protocol BrowseView: class {
    func update(withRandomMovie: Movie)
    func showError(description: String)
}

protocol BrowsePresenter {
    
    var view: BrowseView? { get set }
    
    var genres: [Genre] { get }
    
    func refresh()
    func showRandomMovieDetails()
    func select(genre: Genre)
    func loadSearchResultsScene()
    
}

class BrowsePresenterDefault: BrowsePresenter, MovieDetailsPresenterInput, DetailedMovieSearchPresenterInput {
   
    private let router: Router
    private let randomMovieProvider: RandomMovieProvider
    
    init(router: Router, randomMovieProvider: RandomMovieProvider) {
        self.router = router
        self.randomMovieProvider = randomMovieProvider
    }
    
    var view: BrowseView?
    
    let genres = Genre.allCases
    
    private(set) var selectedGenres: [Genre] = []
    
    var selectedMovie: Movie?
    
    func refresh() {
        randomMovieProvider.fetch { [weak self] result in
            switch result {
            case .success(let movie):
                self?.selectedMovie = movie
                self?.view?.update(withRandomMovie: movie)
                
            case .error(let description):
                self?.view?.showError(description: description)
            }
        }
    }
    
    func showRandomMovieDetails() {
        router.showMovieDetailsScene(fromMovieDetailsPresenterInput: self)
    }
    
    func select(genre: Genre) {
        selectedGenres = [genre]
        router.showGenreExplorer(input: self)
    }
    
    func loadSearchResultsScene() {
        router.loadSearchResultsScene()
    }
    
}
