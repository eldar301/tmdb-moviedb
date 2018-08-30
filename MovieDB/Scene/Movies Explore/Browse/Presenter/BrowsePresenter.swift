//
//  BrowsePresenter.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 27/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

protocol BrowseView: class {
    func update()
    func showError(description: String)
}

protocol BrowsePresenter {
    
    var view: BrowseView? { get set }
    
    var genresCount: Int { get }
    
    func refresh()
    func randomMovieConfigurator() -> RandomMovieConfigurator
    func showDetails()
    func titleForGenre(atIndex: Int) -> String
    func selectGenre(withIndex: Int)
    
}

struct RandomMovieConfigurator {
    
    let title: String?
    let overview: String?
    let backdropURL: URL?
    let voteAverage: Double?
    let voteCount: Int?
    let year: Int?
    
    init(movie: Movie) {
        var year: Int?
        if let releaseDate = movie.releaseDate {
            year = Calendar.current.component(.year, from: releaseDate)
        }
    
        self.title = movie.title
        self.overview = movie.overview
        self.backdropURL = movie.backdropURL ?? movie.posterURL
        self.voteAverage = movie.voteAverage
        self.voteCount = movie.voteCount
        self.year = year
    }
    
}

class BrowsePresenterDefault: BrowsePresenter, MovieDetailsPresenterInput {
    
    fileprivate let router: Router
    fileprivate let randomMovieProvider: RandomMovieProvider
    
    init(router: Router, randomMovieProvider: RandomMovieProvider) {
        self.router = router
        self.randomMovieProvider = randomMovieProvider
    }
    
    var view: BrowseView?
    
    private(set) var selectedMovie: Movie?
    
    private(set) var selectedGenre: Genre?
    
    fileprivate var genres = Genre.allCases
    
    var genresCount: Int {
        return genres.count
    }
    
    func refresh() {
        randomMovieProvider.fetch { [weak self] result in
            switch result {
            case .success(let movie):
                self?.selectedMovie = movie
                self?.view?.update()
                
            case .error(let description):
                self?.view?.showError(description: description)
            }
        }
    }
    
    func randomMovieConfigurator() -> RandomMovieConfigurator {
        assert(selectedMovie != nil, "Random movie should not be nil")
        
        return RandomMovieConfigurator(movie: selectedMovie!)
    }
    
    func showDetails() {
        router.showMovieDetailsScene(fromMovieDetailsPresenterInput: self)
    }
    
    func titleForGenre(atIndex index: Int) -> String {
        return genres[index].localizedString
    }
    
    func selectGenre(withIndex index: Int) {
        selectedGenre = genres[index]
//        router.showGenreExplorer(input: self)
    }
    
}
