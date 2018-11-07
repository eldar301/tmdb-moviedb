//
//  NetworkHelper.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 20/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

enum NetworkError: Error {
    case failedToParseResponse
}

protocol NetworkHelper {
    func jsonTask(request: URLRequest, completition: @escaping (Result<JSON>) -> ())
}

class NetworkHelperDefault: NetworkHelper {
    
    func jsonTask(request: URLRequest, completition: @escaping (Result<JSON>) -> ()) {
        Alamofire
            .request(request)
            .validate()
            .responseJSON(queue: DispatchQueue.main, options: [], completionHandler: { response in
                switch response.result {
                case .success(let value):
                    completition(.success(JSON(value)))
                    
                case .failure(let error):
                    completition(.error(error.localizedDescription))
                }
            })
    }
    
}
