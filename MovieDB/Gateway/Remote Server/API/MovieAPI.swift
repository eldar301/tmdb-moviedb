//
//  MovieAPI.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

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
    case fullData(movieID: Int)
    
    var urlRequest: URLRequest {
        var url: URL
        
        switch self {
        case .details(let movieID):
            url = APIHelper.url(forEndpoint: "movie/\(movieID)", queries: [:])
            
        case .credits(let movieID):
            url = APIHelper.url(forEndpoint: "movie/\(movieID)/credits", queries: [:])
            
        case .videos(let movieID):
            url = APIHelper.url(forEndpoint: "movie/\(movieID)/videos", queries: [:])
            
        case .reviews(let movieID):
            url = APIHelper.url(forEndpoint: "movie/\(movieID)/reviews", queries: [:])
            
        case .fullData(let movieID):
            url = APIHelper.url(forEndpoint: "movie/\(movieID)", queries: ["append_to_response": "credits,videos,reviews"])
            print(url)
        }
        
        return URLRequest(url: url)
    }
    
}
