//
//  GenreExplorerPresenter.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 28/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

protocol DetailedSearchSettingsPresenterInput: class {
    var selectedGenres: [Genre] { get }
    var selectedSortOption: SortBy { get }
    var selectedYearFrom: Int { get }
    var selectedYearTo: Int { get }
    var selectedRatingFrom: Double { get }
    var selectedRatingTo: Double { get }
}

protocol DetailedSearchSettingsPresenterOutput: class {
    func setup(fromYear: Int, toYear: Int, fromRating: Double, toRating: Double, sortOptionIndex: SortBy, selectedGenres: [Genre])
}

struct DetailedSearchSettingsConfigurator {
    let minYear: Int
    let minChosenYear: Int
    let maxYear: Int
    let maxChosenYear: Int
    let minRating: Double
    let minChosenRating: Double
    let maxRating: Double
    let maxChosenRating: Double
    let selectedSortOptionIndex: Int
    let sortOptions: [String]
    let selectedGenreIndices: [Int]
    let genreOptions: [String]
}

protocol DetailedSearchSettingsPresenter {
    func configurator() -> DetailedSearchSettingsConfigurator
    func setup(fromYear: Int, toYear: Int, fromRating: Double, toRating: Double, sortOptionIndex: Int, genreOptionsIndices: [Int])
    func cancel()
}

class DetailedSearchSettingsPresenterDefault: DetailedSearchSettingsPresenter {
    
    fileprivate let router: Router
    
    fileprivate weak var output: DetailedSearchSettingsPresenterOutput?
    
    fileprivate let selectedGenres: [Genre]
    fileprivate let selectedSortOption: SortBy
    fileprivate let selectedYearFrom: Int
    fileprivate let selectedYearTo: Int
    fileprivate let selectedRatingFrom: Double
    fileprivate let selectedRatingTo: Double
    
    init(router: Router, input: DetailedSearchSettingsPresenterInput, output: DetailedSearchSettingsPresenterOutput) {
        self.router = router
        
        self.selectedSortOption = input.selectedSortOption
        self.selectedGenres = input.selectedGenres
        self.selectedYearFrom = input.selectedYearFrom
        self.selectedYearTo = input.selectedYearTo
        self.selectedRatingFrom = input.selectedRatingFrom
        self.selectedRatingTo = input.selectedRatingTo
        
        self.output = output
    }
    
    fileprivate lazy var supportedSortOptions = SortBy.allCases
    
    fileprivate lazy var supportGenreOptions = Genre.allCases
    
    func configurator() -> DetailedSearchSettingsConfigurator {
        return DetailedSearchSettingsConfigurator(minYear: 1900,
                                                  minChosenYear: selectedYearFrom,
                                                  maxYear: 2018,
                                                  maxChosenYear: selectedYearTo,
                                                  minRating: 0.0,
                                                  minChosenRating: selectedRatingFrom,
                                                  maxRating: 5.0,
                                                  maxChosenRating: selectedRatingTo,
                                                  selectedSortOptionIndex: supportedSortOptions.firstIndex(of: self.selectedSortOption)!,
                                                  sortOptions: supportedSortOptions.map({ $0.localizedString }),
                                                  selectedGenreIndices: selectedGenres.map({ self.supportGenreOptions.firstIndex(of: $0)! }),
                                                  genreOptions: supportGenreOptions.map({ $0.localizedString }))
    }
    
    func setup(fromYear: Int, toYear: Int, fromRating: Double, toRating: Double, sortOptionIndex: Int, genreOptionsIndices: [Int]) {
        output?.setup(fromYear: fromYear,
                      toYear: toYear,
                      fromRating: fromRating,
                      toRating: toRating,
                      sortOptionIndex: supportedSortOptions[sortOptionIndex],
                      selectedGenres: genreOptionsIndices.map({ self.supportGenreOptions[$0] })
        )
        router.dismiss()
    }
    
    func cancel() {
        router.dismiss()
    }
    
}
