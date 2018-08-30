//
//  GenreExplorerPresenter.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 28/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

protocol GenreExplorerPresenterOutput: class {
    func setup(fromYear: Int, toYear: Int, fromRating: Double, toRating: Double, sortOptionIndex: SortBy)
}

struct GenreExplorerConfigurator {
    let minYear: Int
    let maxYear: Int
    let minRating: Double
    let maxRating: Double
    let sortOptions: [String]
}

protocol GenreExplorerPresenter {
    
    func configurator() -> GenreExplorerConfigurator
    func setup(fromYear: Int, toYear: Int, fromRating: Double, toRating: Double, sortOptionIndex: Int)
    
}

class GenreExplorerPresenterDefault: GenreExplorerPresenter {

    fileprivate weak var output: GenreExplorerPresenterOutput?
    
    fileprivate lazy var supportedSortOptions = SortBy.allCases
    
    init(output: GenreExplorerPresenterOutput) {
        self.output = output
    }
    
    func configurator() -> GenreExplorerConfigurator {
        return GenreExplorerConfigurator(minYear: 1900,
                                         maxYear: 2018,
                                         minRating: 0.0,
                                         maxRating: 5.0,
                                         sortOptions: supportedSortOptions.map({ $0.localizedString }))
    }
    
    func setup(fromYear: Int, toYear: Int, fromRating: Double, toRating: Double, sortOptionIndex: Int) {
        output?.setup(fromYear: fromYear,
                      toYear: toYear,
                      fromRating: fromRating,
                      toRating: toRating,
                      sortOptionIndex: supportedSortOptions[sortOptionIndex])
        
    }
    
}
