//
//  MovieDetailsPresenter.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 23/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

protocol MovieDetailsParentPresenter {
    var selectedMovie: Movie? { get }
}

protocol MovieDetailsView: class {
    func update()
    func showError(description: String)
}

struct DetailsConfigurator {
    
    var title: String?
    var overview: String?
    var runtime: String?
    var genres: [String]?
    var releaseDate: String?
    var posterURL: URL?
    var backdropURL: URL?
    var trailerURL: URL?
    var budget: Int?
    var voteAverage: Double?
    var voteCount: Int?
    
    fileprivate init(movie: Movie, dateFormatter: DateFormatter, timeFormatter: DateComponentsFormatter) {
        var formattedRuntime: String?
        if let originalRuntime = movie.runtime, originalRuntime > 0 {
            formattedRuntime = timeFormatter.string(from: Double(originalRuntime * 60))
        }
        
        var formattedReleaseDate: String?
        if let originalReleaseDate = movie.releaseDate {
            formattedReleaseDate = dateFormatter.string(from: originalReleaseDate)
        }
        
        var formattedGenres: [String]?
        if let originalGenres = movie.genres {
            formattedGenres = originalGenres.map({ $0.localizedString })
        }
        
        self.title = movie.title
        self.overview = movie.overview
        self.runtime = formattedRuntime
        self.genres = formattedGenres
        self.releaseDate = formattedReleaseDate
        self.posterURL = movie.posterURL ?? movie.backdropURL
        self.backdropURL = movie.backdropURL ?? movie.posterURL
        self.trailerURL = movie.trailerURL
        self.budget = movie.budget
        self.voteAverage = movie.voteAverage
        self.voteCount = movie.voteCount
    }
    
}

struct CastCellConfigurator {
    
    let name: String?
    let profileImageURL: URL?
    
    fileprivate init(person: Person?) {
        self.name = person?.name
        self.profileImageURL = person?.profileImageURL
    }
    
}

struct ReviewCellConfigurator {
    
    let author: String?
    let content: String?
    
    fileprivate init(review: Review?) {
        self.author = review?.author
        self.content = review?.content
    }
    
}

protocol MovieDetailsPresenter {
    
    var view: MovieDetailsView? { get set }
    
    var reviewsCount: Int { get }
    var castsCount: Int { get }
    
    func request()
    func detailsConfigurator() -> DetailsConfigurator
    func castConfigurator(forIndex: Int) -> CastCellConfigurator
    func reviewConfigurator(forIndex: Int) -> ReviewCellConfigurator
    func showReviews()
    func watchTrailer()
    
}

class MovieDetailsPresenterDefault: MovieDetailsPresenter {
    
    fileprivate let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        
        return dateFormatter
    }()
    
    fileprivate let timeFormatter: DateComponentsFormatter = {
        let timeFormatter = DateComponentsFormatter()
        
        timeFormatter.allowedUnits = [.hour, .minute]
        timeFormatter.unitsStyle = .abbreviated
        
        return timeFormatter
    }()
    
    fileprivate let movieDetailsProvider: MovieDetailsProvider
    
    fileprivate var movie: Movie
    
    init(movie: Movie, movieDetailsProvider: MovieDetailsProvider) {
        self.movie = movie
        self.movieDetailsProvider = movieDetailsProvider
    }
    
    weak var view: MovieDetailsView?
    
    var reviewsCount: Int {
        return movie.reviews?.count ?? 0
    }
    
    var castsCount: Int {
        return movie.persons?.count ?? 0
    }
    
    func request() {
        view?.update()
        movieDetailsProvider.details(forMovieID: movie.id) { [weak self] result in
            switch result {
            case .success(let movie):
                self?.movie = movie
                self?.view?.update()
                
            case .error(let description):
                self?.view?.showError(description: description)
            }
        }
    }
    
    func detailsConfigurator() -> DetailsConfigurator {
        return DetailsConfigurator(movie: movie, dateFormatter: dateFormatter, timeFormatter: timeFormatter)
    }
    
    func castConfigurator(forIndex index: Int) -> CastCellConfigurator {
        return CastCellConfigurator(person: movie.persons?[index])
    }
    
    func reviewConfigurator(forIndex index: Int) -> ReviewCellConfigurator {
        return ReviewCellConfigurator(review: movie.reviews?[index])
    }
    
    func showReviews() {
        print("ToDo")
    }
    
    func watchTrailer() {
        
    }
    
    
}