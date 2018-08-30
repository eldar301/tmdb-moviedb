//
//  RemotePersonDetailsProvider.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

class RemotePersonDetailsProvider: PersonDetailsProvider {
    
    fileprivate var networkHelper: NetworkHelper
    
    init(networkHelper: NetworkHelper) {
        self.networkHelper = networkHelper
    }
    
    func details(forPersonID personID: Int, completition: @escaping (Result<PersonDetails>) -> ()) {
        let request = PersonAPI.fullData(personID: personID).urlRequest
        
        networkHelper.jsonTask(request: request) { [weak self] result in
            self?.handle(result: result, completition: completition)
        }
    }
    
    fileprivate func handle(result: Result<JSON>, completition: @escaping (Result<PersonDetails>) -> ()) {
        switch result {
        case .success(let json):
            let person = Mapper<PersonRS>()
                .map(JSONObject: json.rawValue)!
                .entity
            
            let movies = Mapper<MovieRS>()
                .mapArray(JSONObject: json["combined_credits"]["cast"].rawValue)!
                .compactMap({ $0.entity })
            
            completition(.success((person: person, movies: movies)))
        case .error(let description):
            completition(.error(description))
        }
    }
    
}

