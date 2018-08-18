//
//  APIEndpoint.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 18/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

enum SortBy: String {
    case popularityAscending  = "popularity.asc"
    case popularityDescending = "popularity.desc"
    case ratingAscending      = "vote_average.asc"
    case ratingDescending     = "vote_average.desc"
    case yearAscending        = "release_date.asc"
    case yearDescending       = "release_date.desc"
}

enum Genre: Int {
    case action         = 28
    case adventure      = 12
    case animation      = 16
    case comedy         = 35
    case crime          = 80
    case documentary    = 99
    case drama          = 18
    case family         = 10751
    case fantasy        = 14
    case history        = 36
    case horror         = 27
    case music          = 10402
    case mystery        = 9648
    case romance        = 10749
    case scienceFiction = 878
    case tvMovie        = 10770
    case thriller       = 53
    case war            = 10752
    case western        = 37
}

struct API {
    
    struct BackdropSize {
        let w300 = "w300"
        let w780 = "w780"
        let w1280 = "w1280"
        let original = "original"
    }
    
    struct PosterSize {
        let w92 = "w92"
        let w154 = "w154"
        let w185 = "w185"
        let w342 = "w342"
        let w500 = "w500"
        let w780 = "w780"
        let original = "original"
    }
    
    struct ProfileSize {
        let w45 = "w45"
        let w185 = "w185"
        let h632 = "h632"
        let original = "original"
    }
    
    fileprivate static let apiKey = "c10c04cb3d4049b358a035c060a8502c"
    fileprivate static let baseURL = "https://api.themoviedb.org/3/"
    
    static let imageBaseURL = "https://image.tmdb.org/t/p/"
    
    fileprivate static func url(forEndpoint endpoint: String) -> URL {
        let region = NSLocale().localeIdentifier.replacingOccurrences(of: "_", with: "-")
        let includeAdult = "false"
        
        var configurator = URLComponents(string: baseURL + endpoint)!
        
        configurator.queryItems = [URLQueryItem(name: "api_key", value: apiKey),
                                   URLQueryItem(name: "region", value: region),
                                   URLQueryItem(name: "include_adult", value: includeAdult)]
        
        return configurator.url!
    }
    
}

typealias YearRange = (from: Int, to: Int)

enum SearchAPI {
    
    /*
     https://developers.themoviedb.org/3/search/search-movies
     */
    case search(title: String)
    
    /*
     https://developers.themoviedb.org/3/discover/movie-discover
     */
    case detailedSearch(page: Int, genres: [Genre], yearRange: YearRange, sortBy: SortBy)
    
    /*
     https://developers.themoviedb.org/3/movies/get-popular-movies
     */
    case popular(page: Int)
    
    /*
     https://developers.themoviedb.org/3/movies/get-upcoming
     */
    case topRated(page: Int)
    
    /*
     https://developers.themoviedb.org/3/movies/get-top-rated-movies
     */
    case upcoming(page: Int)
    
    var url: URL {
        switch self {
        case .search(let title):
            let url = API.url(forEndpoint: "search/movie")
            let title = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            var configurator = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            
            configurator.queryItems?.append(URLQueryItem(name: "query", value: title))
            
            return configurator.url!
            
        case .detailedSearch(let page, let genres, let yearRange, let sortBy):
            let url = API.url(forEndpoint: "discover/movie")
            
            let convertedGenres = genres.enumerated().reduce("") { (result, indexedGenre) -> String in
                let (index, genre) = indexedGenre
                var nextResult = result + "\(genre.rawValue)"
                if index < genres.count - 1 {
                    nextResult += ","
                }
                return nextResult
            }
            
            let (fromYear, toYear) = yearRange
            
            var configurator = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            
            configurator.queryItems?.append(contentsOf: [URLQueryItem(name: "page", value: "\(page)"),
                                                         URLQueryItem(name: "with_genres", value: convertedGenres),
                                                         URLQueryItem(name: "release_date.gte", value: "\(fromYear)"),
                                                         URLQueryItem(name: "release_data.lte", value: "\(toYear)"),
                                                         URLQueryItem(name: "sort_by", value: sortBy.rawValue)])
            
            return configurator.url!
            
        case .popular(let page):
            let url = API.url(forEndpoint: "movie/popular")
            
            var configurator = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            
            configurator.queryItems?.append(URLQueryItem(name: "page", value: "\(page)"))
            
            return configurator.url!
            
        case .topRated(let page):
            let url = API.url(forEndpoint: "movie/top_rated")
            
            var configurator = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            
            configurator.queryItems?.append(URLQueryItem(name: "page", value: "\(page)"))
            
            return configurator.url!
            
        case .upcoming(let page):
            let url = API.url(forEndpoint: "movie/upcoming")
            
            var configurator = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            
            configurator.queryItems?.append(URLQueryItem(name: "page", value: "\(page)"))
            
            return configurator.url!
        }
    }
    
}

enum MovieAPI {
    
    /*
     https://developers.themoviedb.org/3/movies/get-movie-details
     */
    case details(movieID: Int)
    
    /*
     https://developers.themoviedb.org/3/movies/get-movie-credits
     */
    case credits(movieID: Int)
    
    /*
     https://developers.themoviedb.org/3/movies/get-movie-videos
     */
    case videos(movieID: Int)

    /*
     https://developers.themoviedb.org/3/movies/get-movie-reviews
     */
    case reviews(movieID: Int)
    
    /*
     https://developers.themoviedb.org/3/getting-started/append-to-response
     */
    case allData(movieID: Int)
    
}

enum PersonAPI {
    
    /*
     https://developers.themoviedb.org/3/people/get-person-details
     */
    case details(personID: Int)
    
    /*
     https://developers.themoviedb.org/3/people/get-person-combined-credits
     */
    case credits(personID: Int)
    
    /*
     https://developers.themoviedb.org/3/getting-started/append-to-response
     */
    case allData(personID: Int)
    
}
