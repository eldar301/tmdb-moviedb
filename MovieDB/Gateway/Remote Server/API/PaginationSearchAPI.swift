//
//  SearchAPI.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

typealias YearRange = ClosedRange<Int>
typealias RatingRange = ClosedRange<Double>

enum PaginationSearchAPI {
    
    /*
     https://developers.themoviedb.org/3/search/search-movies
     */
    case search(title: String)
    
    /*
     https://developers.themoviedb.org/3/discover/movie-discover
     */
    case detailedSearch(genres: [Genre], ratingRange: RatingRange, yearRange: YearRange, sortBy: SortBy)
    
    /*
     https://developers.themoviedb.org/3/movies/get-popular-movies
     */
    case popular
    
    /*
     https://developers.themoviedb.org/3/movies/get-upcoming
     */
    case topRated
    
    /*
     https://developers.themoviedb.org/3/movies/get-movie-reviews
     */
    case reviews(movieID: Int)
    
    /*
     https://developers.themoviedb.org/3/movies/get-top-rated-movies
     */
    
    //    case upcoming(page: Int)
    
    //    func request(page: Int) -> URLRequest {
    //
    //    }
    //
    
    func urlRequest(page: Int) -> URLRequest {
        var url: URL
        
        switch self {
        case .search(let title):
            url = APIHelper.url(forEndpoint: "search/movie",
                                queries: [
                                    "page": "\(page)",
                                    "query": title])
            
        case .detailedSearch(let genres, let ratingRange, let yearRange, let sortBy):
            let convertedGenres = genres.map({ "\(APIHelper.id(forGenre: $0))" }).joined(separator: ",")
            
            let fromRating = ratingRange.lowerBound
            let toRating = ratingRange.upperBound
            
            let fromYear = yearRange.lowerBound
            let toYear = yearRange.upperBound
            
            url = APIHelper.url(forEndpoint: "discover/movie",
                                queries: [
                                    "page": "\(page)",
                                    "with_genres": convertedGenres,
                                    "vote_average.gte": "\(fromRating)",
                                    "vote_average.lte": "\(toRating)",
                                    "release_date.gte": "\(fromYear)",
                                    "release_date.lte": "\(toYear)",
                                    "sort_by": APIHelper.sortDescription(forSort: sortBy)])
            
        case .popular:
            url = APIHelper.url(forEndpoint: "movie/popular", queries: ["page": "\(page)"])
            
        case .topRated:
            url = APIHelper.url(forEndpoint: "movie/top_rated", queries: ["page": "\(page)"])
            
        case .reviews(let movieID):
            url = APIHelper.url(forEndpoint: "movie/\(movieID)/reviews", queries: [:])
            
            //        case .upcoming(let page):
            //            url = API.url(forEndpoint: "movie/upcoming", queries: ["page": "\(page)"])
        }
        
        return URLRequest(url: url)
    }
    
}
