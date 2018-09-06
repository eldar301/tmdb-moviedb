//
//  DetailedMovieSearchPresenter.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 03/09/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

protocol DetailedMovieSearchPresenterInput {
    var selectedGenres: [Genre] { get }
}

protocol DetailedMovieSeachPresenter {
    
    var view: MoviesExploreView? { get set }
    
    var title: String { get }
    
    func request()
    func requestNext()
    
    func showDetailedSearchSettings()
    func showDetails(movie: Movie)
    
}

class DetailedMovieSeachPresenterDefault: MoviesExplorePresenterDefault, DetailedMovieSeachPresenter, DetailedSearchSettingsPresenterInput {
    
    fileprivate let router: Router
    fileprivate let moviesProvider: MoviesProvider
    
    init(router: Router, moviesProvider: MoviesProvider, input: DetailedMovieSearchPresenterInput) {
        self.router = router
        self.moviesProvider = moviesProvider
        self.selectedGenres = input.selectedGenres
        super.init(router: router)
    }
    
    var title: String {
        return selectedGenres.count == 1 ? selectedGenres.first!.localizedString : "Search"
    }
    
    private(set) var selectedGenres: [Genre] = []
    private(set) var selectedSortOption: SortBy = .popularityDescending
    private(set) var selectedYearFrom: Int = 1950
    private(set) var selectedYearTo: Int = 2018
    private(set) var selectedRatingFrom: Double = 3.0
    private(set) var selectedRatingTo: Double = 5.0
    
    func request() {
        moviesProvider.fetchMovies(withGenres: selectedGenres, ratingGreaterThan: selectedRatingFrom, ratingLowerThan: selectedRatingTo, fromYear: selectedYearFrom, toYear: selectedYearTo, sortBy: selectedSortOption) { [weak self] result in
            self?.handleRequestResult(result: result, refreshed: true)
        }
    }
    
    func requestNext() {
        moviesProvider.fetchNext { [weak self] result in
            self?.handleRequestResult(result: result, refreshed: false)
        }
    }
    
    func showDetailedSearchSettings() {
        router.showDetailedSearchSettings(input: self, output: self)
    }
    
}

extension DetailedMovieSeachPresenterDefault: DetailedSearchSettingsPresenterOutput {
    
    func setup(fromYear: Int, toYear: Int, fromRating: Double, toRating: Double, sortOptionIndex: SortBy, selectedGenres: [Genre]) {
        self.selectedGenres = selectedGenres
        self.selectedSortOption = sortOptionIndex
        self.selectedYearFrom = fromYear
        self.selectedYearTo = toYear
        self.selectedRatingFrom = fromRating
        self.selectedRatingTo = toRating
        
        request()
    }
    
}
