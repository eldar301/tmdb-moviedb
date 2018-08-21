//
//  NetworkHelperMock.swift
//  MovieDBTests
//
//  Created by Eldar Goloviznin on 20/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation
import SwiftyJSON
@testable import MovieDB

class NetworkHelperMock: NetworkHelper {
    
    var mockString = ""
    
    func jsonTask(request: URLRequest, completition: @escaping (Result<JSON>) -> ()) {
        let jsonMock = JSON(parseJSON: mockString)
        completition(.success(jsonMock))
    }
    
}
