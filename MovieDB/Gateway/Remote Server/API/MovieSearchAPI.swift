//
//  MovieSearchAPI.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

typealias YearRange = (from: Int, to: Int)
typealias RatingRange = (from: Double, to: Double)

enum MovieSearchAPI {
    
    /*
     https://developers.themoviedb.org/3/search/search-movies
     */
    case search(title: String)
    
    /*
     https://developers.themoviedb.org/3/discover/movie-discover
     */
    case detailedSearch(page: Int, genres: [Genre], ratingRange: RatingRange, yearRange: YearRange, sortBy: SortBy)
    
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
    
    var urlRequest: URLRequest {
        var url: URL
        
        switch self {
        case .search(let title):
            url = API.url(forEndpoint: "search/movie",
                           queries: ["query": title])
            
        case .detailedSearch(let page, let genres, let ratingRange, let yearRange, let sortBy):
            let convertedGenres = genres.map({ "\($0.rawValue)" }).joined(separator: ",")
            
            let (fromRating, toRating) = ratingRange
            
            let (fromYear, toYear) = yearRange
            
            url = API.url(forEndpoint: "discover/movie",
                           queries: [
                            "page": "\(page)",
                            "with_genres": convertedGenres,
                            "vote_average.gte": "\(fromRating)",
                            "vote_average.lte": "\(toRating)",
                            "release_date.gte": "\(fromYear)",
                            "release_date.lte": "\(toYear)",
                            "sort_by": sortBy.rawValue])
            
        case .popular(let page):
            url = API.url(forEndpoint: "movie/popular", queries: ["page": "\(page)"])
            
        case .topRated(let page):
            url = API.url(forEndpoint: "movie/top_rated", queries: ["page": "\(page)"])
            
        case .upcoming(let page):
            url = API.url(forEndpoint: "movie/upcoming", queries: ["page": "\(page)"])
        }
        
        return URLRequest(url: url)
    }
    
}
