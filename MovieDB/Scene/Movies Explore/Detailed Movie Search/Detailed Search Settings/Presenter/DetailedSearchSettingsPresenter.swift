//
//  GenreExplorerPresenter.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 28/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

protocol DetailedSearchSettingsPresenterInput: class {
    var selectedGenre: Genre? { get }
}

protocol DetailedSearchSettingsPresenterOutput: class {
    func setup(fromYear: Int, toYear: Int, fromRating: Double, toRating: Double, sortOptionIndex: SortBy)
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
    let selectedSortOption: String
    let sortOptions: [String]
}

protocol DetailedSearchSettingsPresenter {
    func configurator() -> DetailedSearchSettingsConfigurator
    func setup(fromYear: Int, toYear: Int, fromRating: Double, toRating: Double, sortOptionIndex: Int)
}

class DetailedSearchSettingsPresenterDefault: DetailedSearchSettingsPresenter {

    fileprivate weak var output: DetailedSearchSettingsPresenterOutput?
    
    fileprivate let preselectedGenre: Genre
    
    fileprivate lazy var supportedSortOptions = SortBy.allCases
    
    init?(input: DetailedSearchSettingsPresenterInput, output: DetailedSearchSettingsPresenterOutput) {
        guard let preselectedGenre = input.selectedGenre else {
            return nil
        }
        
        self.preselectedGenre = preselectedGenre
        self.output = output
    }
    
    func configurator() -> DetailedSearchSettingsConfigurator {
        return DetailedSearchSettingsConfigurator(minYear: 1900,
                                                  minChosenYear: 1950,
                                                  maxYear: 2018,
                                                  maxChosenYear: 2018,
                                                  minRating: 0.0,
                                                  minChosenRating: 3.0,
                                                  maxRating: 5.0,
                                                  maxChosenRating: 4.5,
                                                  selectedSortOption: SortBy.popularityAscending.localizedString,
                                                  sortOptions: SortBy.allCases.map({ $0.localizedString }))
    }
    
    func setup(fromYear: Int, toYear: Int, fromRating: Double, toRating: Double, sortOptionIndex: Int) {
        output?.setup(fromYear: fromYear,
                      toYear: toYear,
                      fromRating: fromRating,
                      toRating: toRating,
                      sortOptionIndex: supportedSortOptions[sortOptionIndex])
        
    }
    
}
