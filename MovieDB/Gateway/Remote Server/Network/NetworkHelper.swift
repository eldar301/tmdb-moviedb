//
//  NetworkHelper.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 20/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation
import SwiftyJSON

enum NetworkError: Error {
    case failedToParseResponse
}

protocol NetworkHelper {
    func jsonTask(request: URLRequest, completition: @escaping (Result<JSON>) -> ())
}

class NetworkHelperDefault: NetworkHelper {
    
    func jsonTask(request: URLRequest, completition: @escaping (Result<JSON>) -> ()) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completition(.error(error.localizedDescription))
                return
            }
            
            guard let httpURLResponse = response as? HTTPURLResponse else {
                completition(.error(NetworkError.failedToParseResponse.localizedDescription))
                return
            }
            
            guard 200 ... 299 ~= httpURLResponse.statusCode else {
                completition(.error("Bad response"))
                return
            }
            
            do {
                let json = try JSON(data: data!)
                completition(.success(json))
            } catch let error {
                completition(.error(error.localizedDescription))
            }
        }
    }
    
}
