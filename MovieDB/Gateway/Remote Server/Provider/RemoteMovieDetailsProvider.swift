//
//  RemoteMovieDetailsProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

class RemoteMovieDetailsProvider: MovieDetailsProvider {
    
    fileprivate var networkHelper: NetworkHelper
    
    init(networkHelper: NetworkHelper) {
        self.networkHelper = networkHelper
    }
    
    func details(forMovieID movieID: Int, completition: @escaping (Result<Movie>) -> ()) {
        let request = MovieAPI.fullData(movieID: movieID).urlRequest
        
        networkHelper.jsonTask(request: request) { [weak self] result in
            self?.handle(result: result, completition: completition)
        }
    }
    
    fileprivate func handle(result: Result<JSON>, completition: @escaping (Result<Movie>) -> ()) {
        switch result {
        case .success(let json):
            var movie = Mapper<MovieRS>()
                .map(JSONObject: json.rawValue)!
                .movie
            
            let reviews = Mapper<ReviewRS>()
                .mapArray(JSONObject: json["reviews"]["results"].rawValue)!
                .compactMap({ $0.review })
            
            let persons = Mapper<PersonRS>()
                .mapArray(JSONObject: json["credits"]["cast"].rawValue)!
                .compactMap({ $0.person })
            
            movie.reviews = reviews
            movie.persons = persons
            
            completition(.success(movie))
        case .error(let description):
            completition(.error(description))
        }
    }
    
}
