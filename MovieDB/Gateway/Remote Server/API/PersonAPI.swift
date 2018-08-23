//
//  PersonAPI.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 19/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

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
    case fullData(personID: Int)
    
    var urlRequest: URLRequest {
        var url: URL
        
        switch self {
        case .details(let personID):
            url = APIHelper.url(forEndpoint: "person/\(personID)", queries: [:])
            
        case .credits(let personID):
            url = APIHelper.url(forEndpoint: "person/\(personID)/combined_credits", queries: [:])
            
        case .fullData(let personID):
            url = APIHelper.url(forEndpoint: "person/\(personID)", queries: ["append_to_response": "combined_credits"])
        }
        
        return URLRequest(url: url)
    }
    
}
