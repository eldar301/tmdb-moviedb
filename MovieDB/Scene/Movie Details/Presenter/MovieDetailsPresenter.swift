//
//  MovieDetailsPresenter.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 23/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

protocol MovieDetailsPresenterInput {
    var selectedMovie: Movie? { get }
}

protocol MovieDetailsView: class {
    func update(detailsConfigurator: DetailsConfigurator, reviews: [Review], casts: [Person])
    func showError(description: String)
}

struct DetailsConfigurator {

    let title: String?
    let overview: String?
    let runtime: String?
    let genres: [String]?
    let releaseDate: String?
    let posterURL: URL?
    let backdropURL: URL?
    let trailerID: String?
    let budget: String?
    let voteAverage: Double?
    let voteCount: Int?

    fileprivate init(movie: Movie, dateFormatter: DateFormatter, timeFormatter: DateComponentsFormatter, budgetFormatter: NumberFormatter) {
        var formattedRuntime: String?
        if let originalRuntime = movie.runtime, originalRuntime > 0 {
            formattedRuntime = timeFormatter.string(from: Double(originalRuntime * Constants.Time.runtimeRatioMinutesToHour))
        }

        var formattedReleaseDate: String?
        if let originalReleaseDate = movie.releaseDate {
            formattedReleaseDate = dateFormatter.string(from: originalReleaseDate)
        }

        var formattedGenres: [String]?
        if let originalGenres = movie.genres {
            formattedGenres = originalGenres.map({ $0.localizedString })
        }

        var formattedBudget: String?
        if let originalBudget = movie.budget {
            formattedBudget = "$\(budgetFormatter.string(from: NSNumber(value: originalBudget)) ?? "" )"
        }

        self.title = movie.title
        self.overview = movie.overview
        self.runtime = formattedRuntime
        self.genres = formattedGenres
        self.releaseDate = formattedReleaseDate
        self.posterURL = movie.posterURL ?? movie.backdropURL
        self.backdropURL = movie.backdropURL ?? movie.posterURL
        self.trailerID = movie.trailerID
        self.budget = formattedBudget
        self.voteAverage = movie.voteAverage
        self.voteCount = movie.voteCount
    }

}

protocol MovieDetailsPresenter {

    var view: MovieDetailsView? { get set }

    func request()
    func showReviews()
    func dismiss()

}

class MovieDetailsPresenterDefault: MovieDetailsPresenter {
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = .medium

        return dateFormatter
    }()

    private let timeFormatter: DateComponentsFormatter = {
        let timeFormatter = DateComponentsFormatter()

        timeFormatter.allowedUnits = [.hour, .minute]
        timeFormatter.unitsStyle = .abbreviated

        return timeFormatter
    }()

    private let budgetFormatter: NumberFormatter = {
        let budgetFormatter = NumberFormatter()
        budgetFormatter.groupingSeparator = "."
        budgetFormatter.numberStyle = .decimal
        return budgetFormatter
    }()

    private let provider: MovieDetailsProvider

    private var movie: Movie

    private var casts: [Person] = []

    private var reviews: [Review] = []

    private let router: Router

    init?(router: Router, input: MovieDetailsPresenterInput, provider: MovieDetailsProvider) {
        guard let movie = input.selectedMovie else {
            return nil
        }

        self.router = router
        self.movie = movie
        self.provider = provider
    }

    weak var view: MovieDetailsView?

    func request() {
        view?.update(detailsConfigurator: detailsConfigurator(), reviews: [], casts: [])
        provider.details(forMovieID: movie.id) { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success(let details):
                self.movie = details.movie
                self.reviews = details.reviews
                self.casts = details.casts
                self.view?.update(detailsConfigurator: self.detailsConfigurator(), reviews: self.reviews, casts: self.casts)

            case .error(let description):
                self.view?.showError(description: description)
            }
        }
    }

    private func detailsConfigurator() -> DetailsConfigurator {
        return DetailsConfigurator(movie: movie, dateFormatter: dateFormatter, timeFormatter: timeFormatter, budgetFormatter: budgetFormatter)
    }

    func showReviews() {
        print("ToDo")
    }

    func dismiss() {
        router.dismiss()
    }

}

fileprivate struct Constants {
    struct Time {
        static let runtimeRatioMinutesToHour = 60
    }
}
